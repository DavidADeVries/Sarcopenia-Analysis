classdef TextLabel
    %TextLabel a class that holds the handles for a text label
    
    properties
        mainText
        leftBorder
        rightBorder
        topBorder
        bottomBorder
    end
    
    methods
        %% Constructor %%
        function textLabel = TextLabel(varargin)
            % line, unitString, unitConversion, borderColour, fontColour, fontSize
            % point, label, borderColour, fontColour, fontSize
            
            if length(varargin) == 6 %for line
                line = varargin{1};
                unitString = varargin{2};
                unitConversion = varargin{3};    
                
                tagString = line.getTagString(unitString, unitConversion);
                pointX = line.tagPoint(1);
                pointY = line.tagPoint(2);
                
                borderColour = varargin{4};
                fontColour = varargin{5};
                fontSize = varargin{6};
                
                horizontalAlign = line.textAlign;
            else %for point
                point = varargin{1};
                tagString = varargin{2};
                
                pointX = point(1);
                pointY = point(2);
                
                borderColour = varargin{3};
                fontColour = varargin{4};
                fontSize = varargin{5};
                
                horizontalAlign = 'left';
            end           
            
            borderHandles = cell(4,1);
            
            % hold on;
            
            for i=1:4
                handle = text(pointX, pointY, tagString, 'Color', borderColour, 'FontSize', fontSize, 'HorizontalAlignment', horizontalAlign);
                
                borderHandles{i} = handle;
            end
            
            applyBorderShifts(borderHandles);
                        
            textLabel.mainText = text(pointX, pointY, tagString, 'Color', fontColour, 'FontSize', fontSize, 'HorizontalAlignment', horizontalAlign);
            
            textLabel.leftBorder = borderHandles{1};
            textLabel.rightBorder = borderHandles{2};
            textLabel.topBorder = borderHandles{3};
            textLabel.bottomBorder = borderHandles{4};
            
            % hold off;
        end
                       
        
        %% update %%
        function [] = update(varargin)
            %textLabel, line, unitString, unitConversion
            %textLabel, point, label
            
            textLabel = varargin{1};
            handles = {textLabel.leftBorder, textLabel.rightBorder, textLabel.topBorder, textLabel.bottomBorder};
            
            if length(varargin) == 4 %line
                line = varargin{2};
                unitString = varargin{3};
                unitConversion = varargin{4};
                
                tagString = line.getTagString(unitString, unitConversion);
                
                point = line.tagPoint;
                
                %only line needs to update text
                set(textLabel.mainText,'String',tagString);
                
                for i=1:4
                    set(handles{i}, 'String', tagString);                
                end
            elseif length(varargin) >= 2 %point
                point = varargin{2};
                
                if length(varargin) == 3
                    label = varargin{3};
                    
                    set(textLabel.mainText,'String',label);
                    
                    for i=1:4
                        set(handles{i}, 'String', label);
                    end
                end
            end
            
            %update positioning for line or for point
            set(textLabel.mainText,'Position',point);
                        
            for i=1:4
                set(handles{i}, 'Position', point);                
            end
            
            applyBorderShifts(handles);
        end
        
        %% setVisible %%
        
        function [] = setVisible(textLabel, setting) %sets all handles 'Visible' field. setting is 'on' or 'off'
            set(textLabel.mainText, 'Visible', setting);
            set(textLabel.leftBorder, 'Visible', setting);
            set(textLabel.rightBorder, 'Visible', setting);
            set(textLabel.topBorder, 'Visible', setting);
            set(textLabel.bottomBorder, 'Visible', setting);
        end
        
        %% delete %%
        
        function [] = delete(textLabel)
            delete(textLabel.mainText);
            delete(textLabel.leftBorder);
            delete(textLabel.rightBorder);
            delete(textLabel.topBorder);
            delete(textLabel.bottomBorder);
        end
        
        %% setAbsolutePosition %%
        function [] = setAbsolutePosition(textLabel, position)
            handles = {textLabel.mainText, textLabel.leftBorder, textLabel.rightBorder, textLabel.topBorder, textLabel.bottomBorder};
            
            for i=1:length(handles)
                handle = handles{i};
                
                set(handle, 'Units', 'pixels');
                pos = get(handle, 'Position');
                set(handle, 'Position', [pos(1) + position(1), pos(2) - position(2)]);
                set(handle, 'Units', 'data');
            end            
        end
        
        %% bringToTop %%
        function [] = bringToTop(textLabel)
            set(textLabel.leftBorder, 'Layer', 'top');
            set(textLabel.rightBorder, 'Layer', 'top');
            set(textLabel.topBorder, 'Layer', 'top');
            set(textLabel.bottomBorder, 'Layer', 'top');
            
            set(textLabel.mainText, 'Layer', 'top'); %imperative that text is brought to the top last. Or else you won't see it!
        end
        
    end
    
end

