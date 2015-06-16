module OpenCvTool
	require 'open3'
	class OpenCvTool
		attr_accessor :bin_dir
		def initialize(opts = {})
			if RUBY_PLATFORM =~ /cygwin/ 
	  			@bin_dir = opts[:bin_dir] || File.expand_path(File.dirname(__FILE__)) + '/../bin/dist'
			else
	  			@bin_dir = opts[:bin_dir] || File.expand_path(File.dirname(__FILE__)) + '/../bin'
			end            
			@verbose = opts[:verbose] || false
		end

		def self.array2str(array)
			vals = []
			array.each do |a|
				if a.is_a? Array
					vals << self.array2str(a)
				else
					vals << a.to_s
				end
			end
			return "[" + vals.join(",") + "]"
		end


		def self.str2array(str)
			eval(str)
		end

	    def cygpath(filepath, option = "u")
	        command = "cygpath -#{option} #{filepath}"
	        puts "#{command}..." if @verbose
	        out, error, status = Open3.capture3(command)
	        return out.chomp    
	    end


	    def myexpand_path(path)
	        path = File.expand_path(path)
	        path = cygpath(path, "m") if RUBY_PLATFORM.downcase =~ /cygwin/
	        path.gsub(/\s/,"\ ")        
	    end

		def array2str(args) 
			self.class.array2str(args)
		end

		def str2array(args) 
			self.class.str2array(args)
		end

		def command(name)
			#File.join(@bin_dir, name)
			name
		end

		def H_from_points(from_points, to_points)
			#cmd = File.join(@bin_dir, 'H_from_points')
			cmd = command('H_from_points')			
			cmd += " #{array2str(from_points)} #{array2str(to_points)}" 
			r = exec_command(cmd)
	     	if !r.empty?
	     		return eval(r.chomp)
	     	end
		end

	    def Haffine_from_params(opts = {})
	        #cmd = File.join(@bin_dir, 'Haffine_from_params')
			cmd = command('Haffine_from_params')	        
	        cmd += " --angle=#{opts[:angle]}" if opts[:angle]
	        cmd += " --scale=#{opts[:scale]}" if opts[:scale]
	        cmd += " --center=#{array2str(opts[:center])}" if opts[:center]
	        r = exec_command(cmd)
	        if !r.empty?
	            return eval(r.chomp)
	        end
	    end

	    def transform_points(points, opts = {})
			#cmd = File.join(@bin_dir, 'transform_points')
			cmd = command('transform_points')
	    	cmd += " #{array2str(points)}"
	    	cmd += " --matrix=#{array2str(opts[:matrix])}" if opts[:matrix]
	    	r = exec_command(cmd)
	    	if !r.empty?
	    		return eval(r.chomp)
	    	end
	    end

	    def warp_image(image_path, opts = {})
			#cmd = File.join(@bin_dir, 'warp_image')
			cmd = command('warp_image')
	    	cmd += " \"#{myexpand_path(image_path)}\""
	    	cmd += " --output-file=\"#{myexpand_path(opts[:output_file])}\"" if opts[:output_file]    	
	    	cmd += " --background-image=\"#{myexpand_path(opts[:background_image])}\"" if opts[:background_image]
	    	cmd += " --geometry=#{array2str(opts[:geometry])}" if opts[:geometry]
	    	cmd += " --matrix=#{array2str(opts[:matrix])}" if opts[:matrix]
	 	  	cmd += " --corners=#{array2str(opts[:corners])}" if opts[:corners]
	 	  	exec_command(cmd)
	    end

	    def crop_image(image_path, opts = {})
	        # image_path = File.expand_path(image_path)
	        # image_path = cygpath(image_path, "m") if RUBY_PLATFORM.downcase =~ /cygwin/
	        #out_path = myexpand_path(opts[:output_file])
			#cmd = File.join(@bin_dir, 'crop_image')
			cmd = command('crop_image')
	    	cmd += " \"#{myexpand_path(image_path)}\""
	    	cmd += " --output-file=\"#{myexpand_path(opts[:output_file])}\"" if opts[:output_file]    	
	    	cmd += " --geometry=#{opts[:geometry]}" if opts[:geometry]
	 	  	exec_command(cmd)
	    end

	    def exec_command(command)
	    	puts "#{command}..." if @verbose
	    	out, error, status = Open3.capture3(command)
	    	if @verbose
	    		puts out if out && !out.empty?
	    		puts error if error && !error.empty?
	    		puts status if status
	    	end
	    	return out unless out.empty?
	      	# vals = out.chomp.split(' ')
	      	# status_text = vals.shift
	      	# raise 'invalid args' + " #{command}" unless status_text == 'SUCCESS'
	      	# return vals
	    end

	end
end
