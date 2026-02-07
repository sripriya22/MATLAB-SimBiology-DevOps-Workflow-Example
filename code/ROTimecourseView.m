classdef ROTimecourseView < handle
    
    properties ( Access = private )
        ThresholdStyle   = {'Color','r','Linewidth',2,'LineStyle','--',...
            'FontWeight','bold','LabelVerticalAlignment','middle'}; % style for threshold lines

        Linewidth = 2.5
    end

    properties ( Hidden, SetAccess=private)
        % Leave these properties Hidden but public to enable access for any test generated
        % with Copilot during workshop

        lhRO
        Axes

    end

    properties ( Access = public ) 
        ConcColors = [0.30,0.75,0.93;...
                      0.86,0.55,0.41;...
                      0.91,0.73,0.42]; % colors to plot concentrations
        ROColors = [0.30,0.75,0.93];
        FontName = "Helvetica";
    end
    
    properties( Access = private )
        DataListener % listener
    end
    
    methods
        function obj = ROTimecourseView(parent, model)

            arguments
                parent 
                model (1,1) SimulationModel
            end
            
            ax = uiaxes(parent);
            ax.ColorOrder = obj.ROColors;
            xlabel(ax, "Time (hours)", 'FontName',obj.FontName);
            ylabel(ax, "RO (%)",'FontName',obj.FontName);

            obj.lhRO = plot(ax, NaN, NaN,'Linewidth',obj.Linewidth);
            yline(ax,model.ThresholdValues(1), '--','efficacy','FontName',obj.FontName,obj.ThresholdStyle{:});
            yline(ax,model.ThresholdValues(2), '--','safety','FontName',obj.FontName,obj.ThresholdStyle{:});
            grid(ax,"on");
                
            % set limits
            ax.XLimitMethod = "padded";
            ylim(ax,[-5, 105]);
        
            % instantiate listener
            dataListener = event.listener( model, 'DataChanged', ...
                @obj.update );
            
            % store listeners
            obj.DataListener = dataListener;
            
            % save objects
            obj.Axes = ax;
            
        end % constructor
        
   
    end % public methods
    
    methods ( Access = private )
        
        function update(obj,srcModel,~)
            t = srcModel.SimDataTable;

            set(obj.lhRO,'XData',t.Time, 'YData',100*t.RO);
            
        end % update

    end % private method
end % class

