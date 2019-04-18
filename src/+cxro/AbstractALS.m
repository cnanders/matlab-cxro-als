classdef AbstractALS < handle
    
    
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Abstract)
        
        % Returns the gap of BL 12 undulator in mm
        % @return {double 1x1}
        getGapOfUndulator12(this)
        
        % Sets the gap of BL12 undulator
        % @param {double 1x1} dVal - gap in mm
        setGapOfUndulator12(this, dVal)
        
        % Returns the current in the storage ring in A
        % @return {double 1x1}
        getCurrentOfRing(this)
        
    end
    
end

