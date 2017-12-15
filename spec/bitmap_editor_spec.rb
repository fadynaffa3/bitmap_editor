require_relative 'spec_helper'
require 'bitmap_editor'

describe BitmapEditor do
  let(:editor) { BitmapEditor.new() }

  describe '#run' do
    before(:each) { allow_any_instance_of(BitmapEditor).to receive(:validate_file!) }

    context 'create' do
      it 'create a new M x N image with all pixels coloured white (O)' do
        allow(File).to receive(:open).and_return(['I 1 1', 'S'])
        expect { editor.run('somefile.txt') }.to output("O\n").to_stdout

        allow(File).to receive(:open).and_return(['I 2 3', 'S'])
        expect { editor.run('somefile.txt') }.to output("O O\nO O\nO O\n").to_stdout
      end

      it 'will return command invalid when not sending n and m vals' do
        allow(File).to receive(:open).and_return(['I', 'S'])
        expect { editor.run('somefile.txt') }.to output("Invalid Command :(\n").to_stdout
      end

      it 'will return out of bound when sending n more than MAX_COLUMNS' do
        allow(File).to receive(:open).and_return(['I 260 1', 'S'])
        expect { editor.run('somefile.txt') }.to output("out of bound\n").to_stdout
      end
    end

    context 'change colour' do
      it 'colours the pixel (X,Y) with colour C' do
        allow(File).to receive(:open).and_return(['I 2 3', 'L 1 1 C' , 'S'])
        expect { editor.run('somefile.txt') }.to output("C O\nO O\nO O\n").to_stdout
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
      it 'clears the table, setting all pixels to white (O)' do
        allow(File).to receive(:open).and_return(['I 2 3', 'L 1 1 B' , 'C', 'S'])
        expect { editor.run('somefile.txt') }.to output("O O\nO O\nO O\n").to_stdout
      end

      it 'will return no image found when clear without image' do
        allow(File).to receive(:open).and_return(['C' , 'S'])
        expect { editor.run('somefile.txt') }.to output("There is no image\n").to_stdout
      end
    end

    context 'draw horizontal' do
      it 'Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive)' do
        allow(File).to receive(:open).and_return(['I 2 3', 'H 1 1 1 B' , 'S'])
        # B O
        # O O
        # O O
        expect { editor.run('somefile.txt') }.to output("B O\nO O\nO O\n").to_stdout

        allow(File).to receive(:open).and_return(['I 5 4', 'H 2 3 3 B' , 'S'])
        # O O O O O
        # O O O O O
        # O B B O O
        # O O O O O
        expect { editor.run('somefile.txt') }.to output("O O O O O\nO O O O O\nO B B O O\nO O O O O\n").to_stdout
      end

      it 'will return error when try to change an out of bound pixel' do
        allow(File).to receive(:open).and_return(['I 2 3', 'H 5 5 5 B' , 'S'])
        expect { editor.run('somefile.txt') }.to output("out of bound\n").to_stdout
      end

      it 'will return no image found when try to draw without image' do
        allow(File).to receive(:open).and_return(['H 1 1 1 B' , 'S'])
        expect { editor.run('somefile.txt') }.to output("There is no image\n").to_stdout
      end
    end

    context 'draw vertical' do
      it 'Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive)' do
        allow(File).to receive(:open).and_return(['I 2 3', 'V 1 1 2 B' , 'S'])
        # B O
        # B O
        # O O
        expect { editor.run('somefile.txt') }.to output("B O\nB O\nO O\n").to_stdout

        allow(File).to receive(:open).and_return(['I 5 4', 'V 2 3 3 B' , 'S'])
        # O O O O O
        # O O O O O
        # O B O O O
        # O O O O O
        expect { editor.run('somefile.txt') }.to output("O O O O O\nO O O O O\nO B O O O\nO O O O O\n").to_stdout
      end

      it 'will return error when try to change an out of bound pixel' do
        allow(File).to receive(:open).and_return(['I 2 3', 'V 5 5 5 B' , 'S'])
        expect { editor.run('somefile.txt') }.to output("out of bound\n").to_stdout
      end

      it 'will return no image found when try to draw without image' do
        allow(File).to receive(:open).and_return(['V 1 1 1 B' , 'S'])
        expect { editor.run('somefile.txt') }.to output("There is no image\n").to_stdout
      end
    end
  end
end
