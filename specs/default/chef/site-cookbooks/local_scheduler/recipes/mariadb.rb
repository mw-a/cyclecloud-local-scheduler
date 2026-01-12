return if node[:slurm].nil? or node[:slurm][:accounting].nil? or node[:slurm][:accounting][:enabled].nil? or not node[:slurm][:accounting][:enabled]
return if not node[:slurm][:accounting][:url].nil? and not node[:slurm][:accounting][:url].empty?
return if node[:slurm][:role].nil? or node[:slurm][:role] != "scheduler"

package "mariadb-server"

service "mariadb" do
        action [ :enable, :start ]
end
