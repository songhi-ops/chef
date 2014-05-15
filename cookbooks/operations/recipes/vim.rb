
package 'vim' do
  action :install
end


unless ::File.directory?("#{node['operations']['vim']['vim_directory']}") 
        directory "#{node['operations']['vim']['vim_directory']}" do
          owner 'root'
          group 'root'
          mode '0755'
          action :create
        end
end

# Install Pathogen 
unless ::File.directory?("#{node['operations']['vim']['vim_directory']}/autoload") 
        directory "#{node['operations']['vim']['vim_directory']}/autoload" do
          owner 'root'
          group 'root'
          mode '0755'
          action :create
        end
end

unless ::File.directory?("#{node['operations']['vim']['vim_directory']}/bundle") 
        directory "#{node['operations']['vim']['vim_directory']}/bundle" do
          owner 'root'
          group 'root'
          mode '0755'
          action :create
        end
end

remote_file "#{node['operations']['vim']['vim_directory']}/autoload/pathogen.vim" do
    source "https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim"
    action :create_if_missing
end

#Nerdtree

git "#{node['operations']['vim']['vim_directory']}/bundle/nerdtree" do
    repository "https://github.com/scrooloose/nerdtree.git"
    action :sync
end

#Solarized theme
git "#{node['operations']['vim']['vim_directory']}/bundle/vim-colors-solarized" do
    repository "git://github.com/altercation/vim-colors-solarized.git"
    action :sync
end


# vimrc

template "#{node['operations']['vim']['vimrc_file']}"  do
  cookbook node['operations']['template_cookbook']
  source 'vimrc.erb'
  group 'root'
  owner 'root'
  mode 0755
  variables(
  )
  action :create
end

#Adding alias to bashrc
#
bash 'add alias to .bashrc and copy everything to  /etc/skel' do
    code <<-EOF
    egrep 'alias vi=vim' #{node['operations']['bashrc_file']}
    if [ "$?" == "1" ]
        then
        echo 'alias vi=vim' >> #{node['operations']['bashrc_file']}
    fi

    egrep 'export EDITOR' #{node['operations']['bashrc_file']}
    if [ "$?" == "1" ]
        then
        echo 'export EDITOR='`which vim` >> #{node['operations']['bashrc_file']}
    fi

    cp -R #{node['operations']['vim']['vim_directory']} /etc/skel/
    cp #{node['operations']['vim']['vimrc_file']} /etc/skel/
    cp -f #{node['operations']['bashrc_file']} /etc/skel/
    EOF
end

