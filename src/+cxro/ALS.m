classdef ALS < cxro.AbstractALS
    
    
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    
    % PV = process variable
    
    properties (Constant)
        
        cPV_GET_GAP_OF_UNDULATOR_12 = 'SR12U___GDS1PS_AM00'
        cPV_SET_GAP_OF_UNDULATOR_12 = 'cmm:ID12_bl_input'
        cPV_GET_CURRENT_OF_RING = 'cmm:beam_current'
        
        
    end
    
    properties (Access = private)
        
        % {ch.psi.jcae.Channels 1x1}
        channelGetCurrentOfRing
        channelGetGapOfUndulator12
        
        
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
            
            
            properties = java.util.Properties();
            properties.setProperty('EPICS_CA_ADDR_LIST', '131.243.90.255');
            context = ch.psi.jcae.Context(this.properties);
            
            descriptor = ch.psi.jcae.ChannelDescriptor(...
                'double', ...
                this.cPV_GET_CURRENT_OF_RING ...
            );
            
            this.channelGetCurrentOfRing = ch.psi.jcae.Channels.create(...
                context, ...
                descriptor ...
            );
        

            descriptor = ch.psi.jcae.ChannelDescriptor(...
                'double', ...
                this.cPV_GET_GAP_OF_UNDULATOR_12 ...
            );
        
            this.channelGetGapOfUndulator12 = ch.psi.jcae.Channels.create(...
                context, ...
                descriptor ...
            );
        end
        
        % Returns the gap of BL 12 undulator in mm
        % @return {double 1x1}
        function d = getGapOfUndulator12(this)
            
            try
                d = this.channelGetGapOfUndulator12.get();
            catch mE
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
            
        end
        
        % Returns the current in the storage ring in A
        % @return {double 1x1}
        function d = getCurrentOfRing(this)
            
            try
                d = this.channelGetCurrentOfRing.get();
            catch mE
                d = 0;
            end
            
        end
        
        
    end
    
    
    
end

