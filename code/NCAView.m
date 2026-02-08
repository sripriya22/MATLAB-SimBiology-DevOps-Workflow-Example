classdef NCAView < handle
    
    properties ( Access = private )
        NCApanel
        GridLayout
        BackgroundColor = [1,1,1]
    end

    properties ( Hidden )
        % Leave these properties Hidden but public to enable access for any test generated
        % with Copilot during workshop
        NCAtable
    end

    properties ( Access = public ) 
        FontName                (1,1) string = "Helvetica"
        NCAoptions              % options for NCA calculations
        ConcentrationColumnName (1,1) string = "Complex"
        
    end

    properties ( Dependent )
        Color
    end
    
    properties( Access = private )
        DataListener % listener
    end
    
    methods
        function obj = NCAView(parent, model)

            arguments
                parent 
                model (1,1) SimulationModel
            end
            
            ncapanel = uipanel(parent);
            ncapanel.Title = "NCA parameters for bound target ('" + ...
                obj.ConcentrationColumnName + "')";
            ncapanel.BackgroundColor = obj.BackgroundColor;
            ncapanel.FontName = obj.FontName;
            ncapanel.BorderType = 'none';

            % Create GridLayout
            gl = uigridlayout(ncapanel);
            gl.ColumnWidth = {'1x'};
            gl.RowHeight = {'1x'};
            gl.Padding = [0 0 0 0];
            gl.BackgroundColor = obj.BackgroundColor;

            % Create NCAtable
            ncat = uitable(gl);
        
            % save NCA options 
            opt = sbioncaoptions;
            opt.concentrationColumnName = obj.ConcentrationColumnName;
            opt.timeColumnName          = 'Time';
            opt.IVDoseColumnName        = 'Dose';

            % instantiate listener
            dataListener = event.listener( model, 'DataChanged', ...
                @obj.update );
            
            % store listeners
            obj.DataListener = dataListener;
            
            % save objects
            obj.NCAoptions = opt;
            obj.NCApanel = ncapanel;
            obj.GridLayout = gl;
            obj.NCAtable = ncat;
            
        end % constructor
        
        function set.Color(obj,value)
            obj.BackgroundColor = value;
            obj.NCApanel.BackgroundColor = value;
            obj.GridLayout.BackgroundColor = value;
        end

        function value = get.Color(obj)
            value = obj.BackgroundColor;
        end
   
    end % public methods
    
    methods ( Access = private )
        
        function update(obj,srcModel,~)

            % compute NCA parameters and display them in table
            ncaParameters = sbionca(srcModel.SimDataTable, obj.NCAoptions);
            obj.NCAtable.ColumnName = ncaParameters.Properties.VariableNames(2:end);
            obj.NCAtable.Data = ncaParameters(:,2:end);
            
        end % update

    end % private method
end % class

