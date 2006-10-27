#!/usr/bin/env ruby -I../rsm


require 'sm_icp'
require 'rsm_sm_loop'

scan_matcher = Sm::ICPC
#scan_matcher = ICP
#scan_matcher = GPM_then_ICP
name = scan_matcher.new.name

params = standard_parameters
params[:doAlphaTest] = 0
params[:doVisibilityTest] = 1
params[:restart] = 0
params[:restart_threshold_mean_error] = 3.0 / 300.0
params[:restart_dt]=      0.03
params[:restart_dtheta]=    1.5 * 3.14 /180
params[:outliers_maxPerc] = 0.85;

params[:doComputeCovariance] = 0

scan_list = []
#scan_list = (447..450).to_a
#scan_list = [552,553,558]
scan_list = [35]

input = File.open '../mbicp_tro_experiment/laserazosSM3.log'

output_file = "out/laserazosSM3.#{name}.#{params.hash}.log"
output = File.open output_file, "w"

puts "Output: #{output_file}"

results = scan_matching(scan_matcher,scan_list,input,output,params)

if scan_list.empty?
	f = File.open("out/laserazosSM3.#{name}.#{params.hash}.params.txt", "w")
	params.each_key do |k|
		f.puts "#{k} = #{params[k]}"
	end
	
	f = File.open("out/laserazosSM3.#{name}.#{params.hash}.txt", "w")
	results.each_index do |i| res = results[i]
		x = res[:x]
		u = res[:u]
		iterations = res[:iterations]
		error = res[:error]
		nvalid = res[:nvalid]
		time = res[:time]
		f.puts "#{i} #{error} #{nvalid} #{error/nvalid} #{iterations} #{time} "+
			"#{x[0]} #{x[1]} #{x[2]} #{u[0]} #{u[1]} #{u[2]}"
	end
end
