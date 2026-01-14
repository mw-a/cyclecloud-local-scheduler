return if node[:slurm].nil? or node[:slurm][:accounting].nil? or node[:slurm][:accounting][:enabled].nil? or not node[:slurm][:accounting][:enabled]
return if not node[:slurm][:accounting][:url].nil? and not node[:slurm][:accounting][:url].empty?
return if node[:slurm][:role].nil? or node[:slurm][:role] != "scheduler"

package "mariadb-server"

service "mariadb" do
  action [ :enable, :start ]
end

cyclecloud_cluster_name = node[:cyclecloud][:cluster][:name]
slurm_cluster_name = cyclecloud_cluster_name.gsub("[^a-zA-Z0-9-]", "-").downcase
slurm_db_cluster_name = slurm_cluster_name.gsub("-", "_")

slurm_user = node[:slurm][:user].fetch(:name, "slurm")
acct_user = node[:slurm][:accounting].fetch(:user)
if acct_user.nil? or acct_user.empty?
  acct_user = "root"
end

grant_create = "grant all privileges on #{slurm_db_cluster_name}_acct_db.* to #{acct_user}@localhost ; create database #{slurm_db_cluster_name}_acct_db"
if slurm_user == acct_user
  grant_command = "create user #{acct_user}@localhost identified via unix_socket ; #{grant_create}"
elsif acct_user == "root"
  # passwordless root login is apparently a real thing :(
  grant_command = "alter user root@localhost identified via mysql_native_password"
else
  grant_command = "create user #{acct_user}@localhost identified via mysql_native_password ; #{grant_create}"
end

execute "grant slurm" do
  command "mysql -e '#{grant_command} ; flush privileges ;'"
end
