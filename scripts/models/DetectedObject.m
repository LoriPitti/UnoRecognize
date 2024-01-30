classdef DetectedObject
  properties
    Symbol
    Color
    BW
    RGB
    MASK
    V
  end

  methods
      function obj = DetectedObject(bw, rgb)
          if nargin > 0
              obj.BW = bw;
              obj.RGB = rgb;
          end
      end
  end
end