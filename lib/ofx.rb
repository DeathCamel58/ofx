# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'bigdecimal'

require 'kconv'

require 'ofx/errors'
require 'ofx/parser'
require 'ofx/parser/ofx102'
require 'ofx/parser/ofx211'
require 'ofx/foundation'
require 'ofx/balance'
require 'ofx/account'
require 'ofx/investment/aggregates/inv_balances'
require 'ofx/investment/aggregates/inv_buy'
require 'ofx/investment/aggregates/inv_sell'
require 'ofx/investment/aggregates/inv_tran'
require 'ofx/investment/aggregates/sec_id'
require 'ofx/investment/transaction_type/bank_transaction'
require 'ofx/investment/transaction_type/buy_debt'
require 'ofx/investment/transaction_type/buy_mutual_fund'
require 'ofx/investment/transaction_type/buy_option'
require 'ofx/investment/transaction_type/buy_other'
require 'ofx/investment/transaction_type/buy_stock'
require 'ofx/investment/transaction_type/closure_option'
require 'ofx/investment/transaction_type/income'
require 'ofx/investment/transaction_type/investment_expense'
require 'ofx/investment/transaction_type/journal_fund'
require 'ofx/investment/transaction_type/journal_security'
require 'ofx/investment/account'
require 'ofx/investment/investment_statement_response'
require 'ofx/investment/transaction'
require 'ofx/sign_on_message/financial_institution'
require 'ofx/sign_on_message/sign_on_response'
require 'ofx/sign_on_message/sign_on_request'
require 'ofx/sign_on_message/status'
require 'ofx/statement'
require 'ofx/transaction'
require 'ofx/version'
require 'ofx/utils'

def OFX(resource, &block)
  parser = OFX::Parser::Base.new(resource).parser

  if block_given?
    if block.arity == 1
      yield parser
    else
      parser.instance_eval(&block)
    end
  end

  parser
end
