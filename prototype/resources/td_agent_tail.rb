property :name, String, name_property: true
property :options, Hash, default: {}
property :tags, Hash, default: {}
property :parse, Hash, default: { :none => {} }

default_action :create

action :create do
  template "/etc/td-agent/conf.d/10-input_#{new_resource.name}.conf" do
    source "td_agent/_tail.conf.erb"
    variables(
      :name => new_resource.name,
      :options => new_resource.options,
      :tags => new_resource.tags,
      :parse => new_resource.parse,
    )
  end
end

