module PrettyCPF
  def self.included(base)
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods
    def cpf
      sc = super
      sc.class_eval do
        def pretty
          pc = self
          pc.insert(3, '.')
          pc.insert(7, '.')
          pc.insert(11, '-')
        end
      end
      sc
    end
  end
end
