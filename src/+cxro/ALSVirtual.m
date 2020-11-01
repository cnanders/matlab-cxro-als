classdef ALSVirtual < cxro.AbstractALS
    
    
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        
        dGapOfUndulator = 40.24;
        dCurrentOfRing = 500;
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
            
        end
        
        
        % Returns the gap of BL 12 undulator in mm
        % @return {double 1x1}
        function d = getGapOfUndulator12(this)
            d = this.dGapOfUndulator;
        end
        
        % Sets the gap of BL12 undulator
        % @param {double 1x1} dVal - gap in mm
        function setGapOfUndulator12(this, dVal)
            
            if ~isa(dVal, 'double')
                fprintf('cxro.ALSVirtual.setGapOfUndulator12 input must be double.\n');
                return;
            end
            
            this.dGapOfUndulator = dVal;
        end
        
        % Returns the current in the storage ring in mA
        % @return {double 1x1}
        function d = getCurrentOfRing(this)
            d = this.dCurrentOfRing + randn(1,1);
        end
    end
    
end

