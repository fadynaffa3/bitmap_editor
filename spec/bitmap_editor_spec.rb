require_relative 'spec_helper'
require 'bitmap_editor'

describe BitmapEditor do
  let(:editor) { BitmapEditor.new() }

  describe '#run' do
    before(:each) { allow_any_instance_of(BitmapEditor).to receive(:validate_file!) }

    context 'create' do
      it 'will create new image of 1 X 1 and set default value to O' do
        allow(File).to receive(:open).and_return(['I 1 1', 'S'])
        expect { editor.run('somefile.txt') }.to output("O\n").to_stdout
      end

      it 'will create new image of 2 X 3 and set default value to 0' do
        allow(File).to receive(:open).and_return(['I 2 3', 'S'])
        expect { editor.run('somefile.txt') }.to output("O O\nO O\nO O\n").to_stdout
      end

      it 'will return command invalid when not sending n and m vals' do
        allow(File).to receive(:open).and_return(['I', 'S'])
        expect { editor.run('somefile.txt') }.to output("Invalid Command :(\n").to_stdout
      end

      it 'will return out of bound when sending n more than 250p' do
        allow(File).to receive(:open).and_return(['I 260 1', 'S'])
        expect { editor.run('somefile.txt') }.to output("out of bound\n").to_stdout
      end
    end

    context 'change colour' do
      it 'will create new image of 2 X 3 and set the value of 1,1 to B' do
        allow(File).to receive(:open).and_return(['I 2 3', 'L 1 1 B' , 'S'])
        expect { editor.run('somefile.txt') }.to output("B O\nO O\nO O\n").to_stdout
      end

      it 'will return error when try to colour out of bound pixel' do
        allow(File).to receive(:open).and_return(['I 2 3', 'L 5 5 B' , 'S'])
        expect { editor.run('somefile.txt') }.to output("out of bound\n").to_stdout
      end

      it 'will return no image found when change colour without image' do
        allow(File).to receive(:open).and_return(['L 1 1 B' , 'S'])
        expect { editor.run('somefile.txt') }.to output("There is no image\n").to_stdout
      end
    end

    context 'clear' do
      it 'will reset image values to default' do
        allow(File).to receive(:open).and_return(['I 2 3', 'L 1 1 B' , 'C', 'S'])
        expect { editor.run('somefile.txt') }.to output("O O\nO O\nO O\n").to_stdout
      end

      it 'will return no image found when clear without image' do
        allow(File).to receive(:open).and_return(['C' , 'S'])
        expect { editor.run('somefile.txt') }.to output("There is no image\n").to_stdout
      end
    end
  end
end
