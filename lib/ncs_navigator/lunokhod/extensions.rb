require 'ncs_navigator/lunokhod'

module NcsNavigator::Lunokhod
  module VariableNaming
    def varname
      'v' + uuid.to_s.gsub('-', '')
    end
  end
end

Lunokhod::Ast.constants.each do |c|
  obj = Lunokhod::Ast.const_get(c)

  if obj.respond_to?(:instance_methods) && obj.instance_methods.include?(:uuid)
    obj.send(:include, NcsNavigator::Lunokhod::VariableNaming)
  end
end
