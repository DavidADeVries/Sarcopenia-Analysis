classdef Date
    %Date MATLAB 2013 doesn't have datetime, so we'll make due
    
    properties
        month %all in numbers, no strings
        day
        year
    end
    
    methods
                
        function date = Date(dicomDate)
            monthString = dicomDate(5:6);
            dayString = dicomDate(7:8);
            yearString = dicomDate(1:4);
            
            date.month = str2num(monthString);
            date.day = str2num(dayString);
            date.year = str2num(yearString);
        end
        
        function bool = lt(dateLeft, dateRight) %define less than
            
            if dateLeft.year > dateRight.year
                bool = false;
            elseif dateLeft.year < dateRight.year
                bool = true;
            else
                if dateLeft.month > dateRight.month
                    bool = false;
                elseif dateLeft.month < dateRight.month
                    bool = true;
                else
                    if dateLeft.day > dateRight.day
                        bool = false;
                    elseif dateLeft.day < dateRight.day
                        bool = true;
                    else %are equal
                        bool = false;
                    end
                end
            end
                    
        end
        
        function string = display(date) %makes string output of date
            monthString = num2str(date.month);
            dayString = num2str(date.day);
            yearString = num2str(date.year);
            
            if length(monthString) == 1
                monthString = strcat('0', monthString);
            end
            
            if length(dayString) == 1
                dayString = strcat('0', dayString);
            end
            
            string = strcat(monthString, '/', dayString, '/', yearString);
        end
        
        function numDays = daysSinceYear0(date)
            dateString = datestr([date.year, date.month, date.day, 0, 0, 0]);
            epoch = cdfepoch(dateString);
            
            numDays = todatenum(epoch); %since 00/00/0000
        end
        
        function string = stringForCsv(date)
            monthString = num2str(date.month);
            
            switch date.month
                case 1
                    monthString = 'Jan';
                case 2
                    monthString = 'Feb';
                case 3
                    monthString = 'Mar';
                case 4
                    monthString = 'Apr';
                case 5
                    monthString = 'May';
                case 6
                    monthString = 'Jun';
                case 7
                    monthString = 'Jul';
                case 8
                    monthString = 'Aug';
                case 9
                    monthString = 'Sep';
                case 10
                    monthString = 'Oct';
                case 11
                    monthString = 'Nov';
                case 12
                    monthString = 'Dec';
            end
            
            dayString = num2str(date.day);
                        
            if length(dayString) == 1
                dayString = strcat('0', dayString);
            end
            
            yearString = num2str(date.year);
            yearString = yearString(3:4); %just last two digits
            
            string = strcat(dayString, '-', monthString, '-', yearString); %this format allows excel to pick the text up as a date
        end
    end
    
end

