return if node[:slurm].nil? or node[:slurm][:role].nil? or node[:slurm][:role] != "scheduler"
return if node[:slurm][:license_servers].nil? or node[:slurm][:license_servers].empty?

cookbook_file "/etc/cron.d/update_slurm_resources" do
	source "update_slurm_resources.crond"
	owner "root"
	group "root"
	mode 0644
	action :create
end

cookbook_file "/etc/logrotate.d/update_slurm_resources" do
	source "update_slurm_resources.logrotate"
	owner "root"
	group "root"
	mode 0644
	action :create
end

license_servers = node[:slurm][:license_servers]
# sigh - single element stringlist arrives as just a string, not an array
if not license_servers.respond_to? :map
	license_servers = [license_servers]
end

template "/opt/update_slurm_resources" do
	source "update_slurm_resources.erb"
	owner "root"
	group "root"
	mode 0755
	# ['prefix:a@b:foo,bar,baz', 'suffix:b@c:blim,blom,blorf'] ->
	# [{:prefix=>"prefix", :server=>"a@b", :features=>["foo", "bar", "baz"]},
	#  {:prefix=>"suffix", :server=>"b@c", :features=>["blim", "blom", "blorf"]}]
	variables(license_servers: license_servers.map{|x| elem = x.split(":")
		{:prefix => elem[0], :server => elem[1], :features => elem[2].split(",")}})
end
