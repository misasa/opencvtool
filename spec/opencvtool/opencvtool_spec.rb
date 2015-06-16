require 'spec_helper'
module OpenCvTool
	describe OpenCvTool do
		let(:cv){ OpenCvTool.new }
		describe "#crop_image" do
			subject { cv.crop_image(path) }
			let(:path){ 'tmp/cat.jpg'}
			it { 
				expect(cv).to receive(:exec_command).with(/^crop_image/) 
				subject
			}
		end

		describe "#warp_image" do
			subject { cv.warp_image(path) }
			let(:path){ 'tmp/cat.jpg'}
			it { 
				expect(cv).to receive(:exec_command).with(/^warp_image/) 
				subject
			}
		end

		describe "#H_from_points" do
			subject { cv.H_from_points(from_points, to_points) }
			let(:from_points){ [[1,1],[2,2],[3,3],[4,4]]}
			let(:to_points){ [[5,5],[6,6],[7,7],[8,8]]}
			it { 
				expect(cv).to receive(:exec_command).with(/^H_from_points/).and_return("[[1,1],[2,2],[3,3],[4,4]]")
				subject
			}
		end

		describe "#Haffine_from_params" do
			subject { cv.Haffine_from_params(:scale => scale) }
			let(:scale){ 0.5 }
			it { 
				expect(cv).to receive(:exec_command).with("Haffine_from_params --scale=#{scale}").and_return("[[1,0,0],[0,1,0],[0,0,1]]")
				subject
			}
		end

		describe "#transform_points" do
			subject { cv.transform_points(points) }
			let(:points){ [[1,0],[2,2]] }
			it {
				expect(cv).to receive(:exec_command).with(/^transform_points/).and_return("[[1,0],[2,2]]")
				subject
			}
		end
	end
end