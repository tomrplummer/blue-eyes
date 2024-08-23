require 'rspec'
require_relative '../../lib/blue_eyes/txt'

RSpec.describe BlueEyes::TXT do
  include BlueEyes::TXT
  describe '#snake_case' do
    it 'converts CamelCase to snake_case' do
      expect(snake_case('CamelCase')).to eq('camel_case')
    end

    it 'handles acronyms correctly' do
      expect(snake_case('HTMLParser')).to eq('html_parser')
    end

    it 'handles single-word strings' do
      expect(snake_case('Word')).to eq('word')
    end
  end

  describe '#pascalize' do
    it 'converts snake_case to PascalCase' do
      expect(pascalize('snake_case')).to eq('SnakeCase')
    end

    it 'handles single-word strings' do
      expect(pascalize('word')).to eq('Word')
    end

    it 'handles strings with multiple underscores' do
      expect(pascalize('multiple_words_string')).to eq('MultipleWordsString')
    end
  end

  describe '#singular' do
    it 'converts plural nouns to singular' do
      expect(singular('cars')).to eq('car')
      expect(singular('boxes')).to eq('box')
    end

    it 'handles already singular nouns' do
      expect(singular('car')).to eq('car')
    end
  end

  describe '#plural' do
    it 'converts singular nouns to plural' do
      expect(plural('car')).to eq('cars')
      expect(plural('box')).to eq('boxes')
    end

    it 'handles already plural nouns' do
      expect(plural('cars')).to eq('cars')
    end
  end
end
