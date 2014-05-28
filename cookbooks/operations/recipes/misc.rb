# Add $PS1

bash "Adding $PS1" do
    code <<-EOF
    egrep 'export PS1' /etc/profile
    if [ "$?" == "1" ]
    then
        echo "export PS1='#{node[:operations][:PS1]}'" >> /etc/profile
    fi
    EOF
end

bash "Adding history settings" do
    code <<-EOF
    egrep 'PROMPT_COMMAND="history -a;\$PROMPT_COMMAND";' /etc/profile
    if [ "$?" == "1" ]
    then
        echo 'PROMPT_COMMAND="history -a;$PROMPT_COMMAND";' >> /etc/profile
    fi

    egrep 'export HISTTIMEFORMAT="%h/%d - %H:%M:%S "' /etc/profile
    if [ "$?" == "1" ]
    then
        echo 'export HISTTIMEFORMAT="%h/%d - %H:%M:%S "' >> /etc/profile
    fi

    EOF
end
