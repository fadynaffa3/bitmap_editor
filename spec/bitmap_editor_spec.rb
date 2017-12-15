require_relative 'spec_helper'
require 'bitmap_editor'

describe BitmapEditor do
  let(:editor) { BitmapEditor.new() }

  describe '#run' do
    before(:each) { allow_any_instance_of(BitmapEditor).to receive(:validate_file!) }

    context 'create' do
      it 'will create new image of 1 X 1 when using I command' do
        allow(File).to receive(:open).and_return(['I 1 1', 'S'])
        expect { editor.run('somefile.txt') }.to output("O\n").to_stdout
      end

      it 'will create new image of 2 X 3 when using I command' do
        allow(File).to receive(:open).and_return(['I 2 3', 'S'])
        expect { editor.run('somefile.txt') }.to output("O O\nO O\nO O\n").to_stdout
      end
    end

    context 'change colour' do
    end
  end
end
