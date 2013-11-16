class Rate_Converter

  def initialize(xml_rates)
    @xml_rates = xml_rates
    @conversion_rates = []
    @USD_rates = {"USD" => 1}
  end

  def find_rates
    @xml_rates.elements.each("rates/rate") do |raw_rate|
      parse_rate = parse(raw_rate)
      @conversion_rates << parse_rate
    end
    return @conversion_rates
  end

  def to_USD
    rate_to_usd = @conversion_rates.select do |rate|
      rate.to == "USD"
    end
    rate_to_usd.each do |rate|
      @USD_rates[rate.from] = rate.conversion
    end
    @conversion_rates.delete_if {|rate| rate.to == "USD"|| rate.from == "USD"}
    find_missing_rates(@conversion_rates)
    return @USD_rates
  end

  private

  def parse(xml_rate)
    rate = OpenStruct.new
    rate.from = xml_rate.elements["from"].text
    rate.to = xml_rate.elements["to"].text
    rate.conversion = xml_rate.elements["conversion"].text
    return rate
  end

  def find_missing_rates(rates)
    while @conversion_rates.any?
      @conversion_rates.each do |rate|
        if @USD_rates.keys.include? (rate.from) 
          @conversion_rates.delete(rate)
        else @USD_rates.include?(rate.to) && !@USD_rates.include?(rate.from)
          @USD_rates[rate.from] = mult(rate.conversion, @USD_rates[rate.to])
          @conversion_rates.delete(rate)
        end
      end
    end
  end

  def mult(a, b)
    c = (a.to_f * b.to_f).to_s
  end
end
