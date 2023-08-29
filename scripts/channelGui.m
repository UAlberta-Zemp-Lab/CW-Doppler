function channelGui
    figure('MenuBar','none',...
        'Name','Channel Select',...
        'NumberTitle','off');
    screen = get(gcf, 'Position');
    screenWidth = screen(3);
    screenHeight = screen(4);
    buttonWidth = 60;
    buttonHeight = 20;
    xscale = 80;
    yscale = 50;
    xoffset = 60;
    yoffset = 20;
    sendoffset = 100;

    channels = gobjects(1, 32);
    for y = 0:7
        for x = 0:3
            index = (4 * y) + x + 1;
            channels(index) = uicontrol('Style','togglebutton',...
                                'String',sprintf("Channel %d", index),...
                                'BackgroundColor','Red',...
                                'Position',[(xscale * x + xoffset), ...
                                            (yscale * y + yoffset), ...
                                            buttonWidth, buttonHeight],...
                                'Callback',@channelButtonCallback);
        end
    end

    uicontrol('Style','pushbutton', ...
        'String', 'Send Data', ...
        'BackgroundColor', 'Magenta', ...
        'Position', [(screenWidth / 2) + sendoffset, ...
                    (screenHeight / 2) - (buttonHeight / 2), ...
                    buttonWidth, buttonHeight], ...
        'Callback', @sendDataCallback);

    uicontrol('Style','pushbutton', ...
        'String', 'Select All', ...
        'BackgroundColor', 'Cyan', ...
        'Position', [(screenWidth / 2) + sendoffset, ...
                    (screenHeight / 2) + (3 * buttonHeight / 2), ...
                    buttonWidth, buttonHeight], ...
        'Callback', @selectAllCallback);

    uicontrol('Style','pushbutton', ...
        'String', 'Deselect All', ...
        'BackgroundColor', 'Red', ...
        'Position', [(screenWidth / 2) + sendoffset, ...
                    (screenHeight / 2) - (5 * buttonHeight / 2), ...
                    buttonWidth, buttonHeight], ...
        'Callback', @deselectAllCallback);

    autoCOMbutton = uicontrol('Style', 'togglebutton', ...
        'String', 'Auto COM', ...
        'BackgroundColor', 'Green', ...
        'Value', 1, ...
        'Position', [(screenWidth / 2) + sendoffset, ...
                    (screenHeight / 2) + (7 * buttonHeight / 2), ...
                    buttonWidth, buttonHeight], ...
        'Callback', @autoCOMCallback);

    autoCOMedit = uicontrol('Style', 'edit', ...
        'String', 'COM', ... 
        'Position', [(screenWidth / 2) + sendoffset + 3 * buttonWidth / 2, ...
                    (screenHeight / 2) + (7 * buttonHeight / 2), ...
                    buttonWidth, buttonHeight], ...
        'Visible','off');

    function channelButtonCallback(src, ~)
        if (src.Value == 0)
            src.BackgroundColor = 'Red';
        else
            src.BackgroundColor = 'Green';
        end
    end

    function autoCOMCallback(src, ~)
        if (src.Value == 0)
            src.BackgroundColor = 'Red';
            autoCOMedit.Visible = 'on';
        else
            src.BackgroundColor = 'Green';
            autoCOMedit.Visible = 'off';
        end
    end

    function selectAllCallback(~, ~)
        for i = 1:32
            channels(i).BackgroundColor = 'Green';
            channels(i).Value = 1;
        end
    end

    function deselectAllCallback(~, ~)
        for i = 1:32
            channels(i).BackgroundColor = 'Red';
            channels(i).Value = 0;
        end
    end
    
    function sendDataCallback(~, ~)
        data = 0;
        for i = 1:32
            data = data + bitshift(channels(i).Value, (i-1));
        end
        if (autoCOMbutton.Value == 1)
            if (sendChannelData(data)) 
                fprintf("0b%s\n", dec2bin(data, 32));
            end
        else
            if (sendChannelData(data, autoCOMedit.String))
                fprintf("0b%s\n", dec2bin(data, 32));
            end
        end
    end
end

function success = sendChannelData(channelData, port)
    arguments
        channelData uint32;
        port string = 'Invalid'
    end
    
    if nargin < 2
        freeports = serialportlist("available");
        if isempty(freeports)
            disp("No serial port found");
            success = false;
            return;
        end
        port = freeports(1);
    end
    
    try
        device = serialport(port, 115200);
        write(device, channelData, 'uint32');
        delete(device);
        success = true;
    catch 
        fprintf("Invalid Port: %s\n", port);
        success = false;
    end
end