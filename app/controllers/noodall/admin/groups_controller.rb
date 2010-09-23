class Admin::GroupsController < Admin::BaseController
  caches_action :index, :expires_in => 1.hour
  def index
    groups = []
    conn = Net::LDAP.new :host => Settings.ldap_host,
                         :port => Settings.ldap_port,
                         :base => Settings.ldap_base,
                         :auth => { :username => "#{Settings.ldap_username}@#{Settings.ldap_domain}",
                                    :password => Settings.ldap_password,
                                    :method => :simple }
    groups = conn.search(:filter => "objectClass=group")

    groups.map! do |ldap_entry|
      ldap_entry.name.to_s
    end
    expires_in 20.minutes
    render :json => groups
  rescue Net::LDAP::LdapError => e
    render :json => []
  end
end