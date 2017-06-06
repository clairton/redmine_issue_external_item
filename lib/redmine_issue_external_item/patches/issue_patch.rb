require_dependency 'issue'

module RedmineIssueExternalItem
  module Patches

    module IssuePatch

      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method_chain :copy_from, :external_items
          has_many :external_items, class_name: 'IssueExternalItem', dependent: :destroy
        end

      end

      module InstanceMethods
        def copy_from_with_external_items(arg, options={})
          copy_from_without_external_items(arg, options)
          issue          = arg.is_a?(Issue) ? arg : Issue.visible.find(arg)
          self.external_items = issue.external_items.map { |cl| cl.dup }
          self
        end

        def update_external_items(external_items_new, create_journal = false)
          external_items_new ||= []

          old_external_items = external_items.collect(&:info).join(', ')

          external_items.destroy_all
          external_items << external_items_new.uniq.collect do |cli|
            IssueExternalItem.new(description: cli[:description], key: cli[:key], quantity: cli[:quantity])
          end

          new_external_items = external_items.collect(&:info).join(', ')

          if current_journal && create_journal && (new_external_items != old_external_items)
            current_journal.details << JournalDetail.new(
              property:  'attr',
              prop_key:  'external_item',
              old_value: old_external_items,
              value:     new_external_items)
          end
          export_order_file
        end

        def export_order_file
          #if status <=> 'Em andamento' 
            
            start_date ||= User.current.today

            #Header
            out = "[CP_REQUISICOESPAI]\n\r\n\r"
            out << "@SERVICO=I\n\r\n\r"
            out << "EMPRESA=1\n\r\n\r"
            out << "FILIAL=24\n\r\n\r"
            out << "NUMERO=\n\r\n\r"
            out << "CONFIRMANTE="+User.current.id.to_s+"\n\r\n\r"
            out << "GRUPODEASSINATURAS=2\n\r\n\r"
            out << "\n\n"

            external_items.each do |item|
                out << "[CP_REQUISICOES]\n\r\n\r"
                out << "@SERVICO=I\n\r\n\r"
                out << "EMPRESA=1 \n\r\n\r"
                out << "FILIAL=24\n\r\n\r"
                out << "REQUISICAOPAI=@CP_REQUISICOESPAI@\n\r\n\r"
                out << "NUMERO=\n\r\n\r"
                out << "DATA="+start_date.strftime("%Y%m%d")+"\n\r\n\r"
                out << "REQUISITANTE=AgenciaX\n\r\n\r"
                out << "CENTROCUSTO=@HANDLE(1)"+"\n\r\n\r"
                out << "PRAZO="+(due_date.nil? ? start_date : due_date).strftime("%d/%m/%Y")+"\n\r\n\r"
                out << "PRODUTO="+item.key.to_s+"\n\r\n\r"
                out << "QUANTIDADE="+item.quantity.to_s+"\n\r\n\r"
                out << "FAMILIA=1\n\r\n\r"
                out << "STATUS=1\n\r\n\r"
                out << "ALMOXARIFADO=2"
                out << "TIPO=O\n\r\n\r"
                out << "UNIDADE=1\n\r\n\r"
                out << "ALMOXARIFADOORIGEM=2\n\r\n\r"
                out << "OPERACAO=1068\n\r\n\r"
                out << "TABTIPO=2\n\r\n\r"
                out << "LIBERADA=N\n\r\n\r"
                out << "TIPOMOVIMENTACAO=1\n\r\n\r"
                out << "NUMEROORIGEM =\n\r\n\r"
                out << "CONFIRMANTE="+User.current.id.to_s+"\n\r\n\r"
                out << "CONFIRMARATE="+(due_date.nil? ? start_date : due_date).strftime("%d/%m/%Y")+"\n\r\n\r"
                out << "K_FILIALREQUISITANTE=1\n\r\n\r"
                out << "\n"
            end

            #Trailler
            out << "[CP_REQUISICOESPAI]\n\r\n\r"
            out << "@SERVICO=V\n\r\n\r"
            out << "*HANDLE=@CP_REQUISICOESPAI@\n\r\n\r"
            out << "\n"

            name = Rails.configuration.issue_external_item.export_dir + DateTime.now.strftime("%Y%m%d%H%M%S%L") + ".att"

            File.open(name, 'w+') { |file| file.write(out) }
          #end
        end
      end

    end

  end
end


unless Issue.included_modules.include?(RedmineIssueExternalItem::Patches::IssuePatch)
  Issue.send(:include, RedmineIssueExternalItem::Patches::IssuePatch)
end
