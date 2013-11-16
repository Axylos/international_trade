require 'bigdecimal'
require './lib/rates_converter'
require './lib/transactions'
require 'rexml/document'
require 'ostruct'
include REXML
require 'csv'

rates_xml = "data/RATES.xml"
rates_xmlfile = File.new(rates_xml)
rates_doc = Document.new(rates_xmlfile)

rates = Rate_Converter.new(rates_doc)
rates.find_rates
rates_to_USD = rates.to_USD

transactions = CSV.open "data/transactions.csv"
trans_totals = Sales.new(transactions)
puts trans_totals.compute_sum(rates_to_USD)

