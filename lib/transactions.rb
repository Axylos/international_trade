class Sales

  def initialize(transactions)
    @transactions = parse(transactions)
  end

  def compute_sum(rates)
    sum = 0
    @transactions.each {|trans| sum += convert(trans, rates)}
    return sum.to_f
  end

  private

  def parse(trans)
    sales = []
    trans.each do |row|
      if row[1] == "DM1182" 
        sale = row[2].split
        sales << [sale[0], sale[1]]
      end
    end
    return sales
  end

  def convert(trans, rates)
    big_mult(trans[0], rates[trans[1]])
  end

  def big_mult(a, b)
    c = a.to_f * b.to_f
    c = BigDecimal.new("#{c}").round(2, BigDecimal::ROUND_HALF_EVEN)
  end
end
