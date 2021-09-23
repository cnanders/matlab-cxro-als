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
                fprintf('cxro.ALSVirtual.setGapOfUndulator12 input must be double.\n');
                return;
            end
            
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
        
        
    end
    
    
    
end

