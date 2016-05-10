function [returnVal] = EmptyHandler(realVal, missingValue)
if isempty(realVal)
    returnVal = missingValue;
else
    returnVal = realVal;
end
end