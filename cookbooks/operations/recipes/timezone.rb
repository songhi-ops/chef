
bash 'timezone - UTC' do
    code <<-EOF
    rm /etc/localtime
    ln -s /usr/share/zoneinfo/UTC /etc/localtime
    EOF
end

