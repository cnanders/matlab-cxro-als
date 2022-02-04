classdef ALS < cxro.AbstractALS
    
    % Relies on epics and labca which get compiled
    % for each OS and Matlab version
    % See Google Doc FIXME 
    
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    
    % PV = process variable
    
    properties (Constant)
        
        cPV_GET_GAP_OF_UNDULATOR_12 = 'SR12U___GDS1PS_AM00'
        cPV_SET_GAP_OF_UNDULATOR_12 = 'cmm:ID12_bl_input'
        cPV_GET_CURRENT_OF_RING = 'cmm:beam_current'
        cPV_GET_OPERATOR_GRANT_OF_UNDULATOR_12 = 'cmm:ID12_opr_grant'
        
        
    end
    
    properties (Access = private)
        
        % {ch.psi.jcae.Channels 1x1}
        channelGetCurrentOfRing
        channelGetGapOfUndulator12
        channelSetGapOfUndulator12
        channelGetOperatorGrantOfUndulator12
        
        lDebug = false
        
        cPath 
        
        
   
        
        
    end
    
    methods
        
        function this = ALS(varargin)
            for k = 1 : 2: length(varargin)
                this.msg(sprintf('passed in %s', varargin{k}));
                if this.hasProp( varargin{k})
                    this.msg(sprintf('settting %s', varargin{k}));
                    this.(varargin{k}) = varargin{k + 1};
                end
            end
            
            this.connect();
            this.checkEnvironmentVariables();
            this.checkMatlabPathForLabCA();
            
        end
        
        function checkMatlabPathForLabCA(this)
            
            c = path;  % matlab path
            if ~contains(c, 'C:\labca_3_5\bin\windows-x64\labca')
                error('MATLAB path must contain path to labca matlab files C:\labca_3_5\bin\windows-x64\labca');
            end
            
        end
        
        
        function checkEnvironmentVariables(this)
            
            % On Windows 10, set up environment variables the easy way
            % by typing "environment variables" into the search bar and 
            % using the GUI.  Can also use setx in the command line but
            % Its much easier to use the GUI because it lets you do user
            % variables and system variables
            
            ceVars = { ...
                'EPICS_CA_MAX_ARRAY_BYTES', '250000000', ...
                'EPICS_CA_ADDR_LIST', '131.243.90.255', ...
                'EPICS_CA_SERVER_PORT', '5064', ...
                'EPICS_HOST_ARCH', 'windows-x64', ...
                'PATH', 'C:\labca_3_5\bin\windows-x64', ...
                'PATH', 'C:\epics\R3.15.5\base\bin\windows-x64' ...
            };
        
            for k = 1 : 2: length(ceVars)
                
                this.msg(sprintf('passed in %s', ceVars{k}));
                cCmd = sprintf('echo %%%s%%', ceVars{k}); % looks like 'echo %PATH%'
                [status, cmdout] = system(cCmd);

                if ~contains(cmdout, ceVars{k+1})
                    cMsg = [ ...
                        sprintf('Environment variable %s', ceVars{k}), ...
                        sprintf(' must be set to %s before MATLAB is launched.', ceVars{k+1}), ...
                        sprintf('Type "environment variables" in start menu to edit OR'), ...
                        sprintf(' Open a command prompt and run setx %s "%s" and restart MATLAB', ceVars{k}, ceVars{k+1}) ...
                    ];
                    error(cMsg);
                end
                
                
            end
                
               
        end
        
        
        % Sets up Channel Access (CA) context and initializes channels for 
        % accessing each desired process variable (PV)
        function connect(this)
            
            
            % NEW
            
            return;
            
            % OLD
            
            properties = java.util.Properties();
            properties.setProperty('EPICS_CA_ADDR_LIST', '131.243.90.255');
            context = ch.psi.jcae.Context(properties);
            
            descriptor = ch.psi.jcae.ChannelDescriptor(...
                'double', ...
                this.cPV_GET_CURRENT_OF_RING, true ...
            );
            
            this.channelGetCurrentOfRing = ch.psi.jcae.Channels.create(...
                context, ...
                descriptor ...
            );
        
            %{
            
            descriptor = ch.psi.jcae.ChannelDescriptor(...
                'double', ...
                this.cPV_GET_GAP_OF_UNDULATOR_12, true ...
            );
        
            this.channelGetGapOfUndulator12 = ch.psi.jcae.Channels.create(...
                context, ...
                descriptor ...
            );
        
            descriptor = ch.psi.jcae.ChannelDescriptor(...
                'double', ...
                this.cPV_SET_GAP_OF_UNDULATOR_12, true ...
            );
        
            this.channelSetGapOfUndulator12 = ch.psi.jcae.Channels.create(...
                context, ...
                descriptor ...
            );
        
            descriptor = ch.psi.jcae.ChannelDescriptor(...
                'double', ...
                this.cPV_GET_OPERATOR_GRANT_OF_UNDULATOR_12, true ...
            );
        
            this.channelGetOperatorGrantOfUndulator12 = ch.psi.jcae.Channels.create(...
                context, ...
                descriptor ...
            );
            
            %}
        
        
        end
        
        function disconnect(this)
            
            return
            
            
            try
            this.channelGetCurrentOfRing.close();
%             this.channelGetGapOfUndulator12.close();
%             this.channelGetOperatorGrantOfUndulator12.close();
%             this.channelSetGapOfUndulator12.close();
            catch mE
                mE
            end
            
        end
        
        % Returns the gap of BL 12 undulator in mm
        % @return {double 1x1}
        function d = getGapOfUndulator12(this)
            
            d = lcaGet(this.cPV_GET_GAP_OF_UNDULATOR_12);
            return;
            
            % OLD 
            
            try
                d = this.channelGetGapOfUndulator12.get();
            catch mE
                rethrow(mE)
                fprintf('cxro.ALSVirtual.getGapOfUndulator() Channel.get() error.\n');
                d = 40.24; % default
            end
        end
        
        % Sets the gap of BL12 undulator
        % @param {double 1x1} dVal - gap in mm
        function setGapOfUndulator12(this, dVal)
            
            if ~isa(dVal, 'double')
                fprintf('cxro.ALS.setGapOfUndulator12 input must be double.\n');
                return;
            end
            
           
            lcaPut(this.cPV_SET_GAP_OF_UNDULATOR_12, dVal);
            
            return
            
            % OLD
            try
                this.channelSetGapOfUndulator12.put(dVal);
            catch mE
                rethrow(mE)
                fprintf('cxro.ALSVirtual.setGapOfUndulator12 Channel.put() error.\n');
            end
            
        end
        
        function d = getOperatorGrantOfUndulator12(this)
            
            try
                d = this.channelGetOperatorGrantOfUndulator12.get();
            catch mE
                rethrow(mE)
                d = 0;
            end
        end
        
        % Returns the current in the storage ring in A
        % @return {double 1x1}
        function d = getCurrentOfRing(this)
            
            d = lcaGet(this.cPV_GET_CURRENT_OF_RING);
                
            return;
            
            try
                d = this.channelGetCurrentOfRing.get();
            catch mE
                mE
                rethrow(mE)
                d = 0;
            end
            
        end
        
        function l = hasProp(this, c)
            
            l = false;
            if ~isempty(findprop(this, c))
                l = true;
            end
            
        end
        
        function msg(this, cMsg)
            if this.lDebug
                fprintf('%s\n', cMsg);
            end
        end
        
        
    end
    
    
    
end

