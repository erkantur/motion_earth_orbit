function satellite_gui
    % Create figure and panels
    fig = figure('Position', [100, 100, 1000, 600], 'MenuBar', 'none', 'Name', 'Satellite Orbit Simulation', 'NumberTitle', 'off', 'Resize', 'off');
    controlPanel = uipanel('Position', [0, 0, 0.3, 1]);
    plotPanel = uipanel('Position', [0.3, 0, 0.7, 1]);
    
    % Create input controls
    uicontrol('Parent', controlPanel, 'Style', 'text', 'Position', [20, 500, 100, 20], 'String', 'Initial Altitude (km):');
    altitudeEdit = uicontrol('Parent', controlPanel, 'Style', 'edit', 'Position', [120, 500, 100, 20], 'String', '35786');

    % Create button to run the simulation
    runButton = uicontrol('Parent', controlPanel, 'Style', 'pushbutton', 'Position', [20, 400, 200, 40], 'String', 'Run Simulation', 'Callback', @runSimulation);
    
    % Plot area
    axes('Parent', plotPanel, 'Position', [0.1, 0.1, 0.8, 0.8]);

    function runSimulation(~, ~)
        % Read initial altitude
        altitude_km = str2double(get(altitudeEdit, 'String')) * 1e3;
        
        % Run simulation with the given altitude
        [t, y] = simulate_orbit(altitude_km);
        
        % Plot results
        plot3(y(:,1), y(:,2), y(:,3), 'b-');
        hold on
        [xE, yE, zE] = sphere(50);
        R_earth = 6371e3;  % Radius of Earth (m)
        surf(R_earth*xE, R_earth*yE, R_earth*zE, 'FaceAlpha', 0.5, 'EdgeColor', 'none')
        axis equal
        xlabel('X (m)')
        ylabel('Y (m)')
        zlabel('Z (m)')
        title('Satellite Orbit Around Earth')
        grid on
    end

    function [t, y] = simulate_orbit(altitude_m)
        % Constants
        G = 6.67430e-11;  % Gravitational constant (m^3 kg^-1 s^-2)
        M_earth = 5.972e24; % Mass of Earth (kg)
        R_earth = 6371e3;  % Radius of Earth (m)

        % Initial Conditions
        r0 = [R_earth + altitude_m, 0, 0]; % Initial position (m)
        v0 = [0, sqrt(G * M_earth / (R_earth + altitude_m)), 0]; % Initial velocity (m/s)
        initial_conditions = [r0, v0];

        % Time span (1 day)
        t_span = [0, 24*3600];

        % Solve the differential equation using ODE45
        options = odeset('RelTol', 1e-9, 'AbsTol', 1e-10);
        [t, y] = ode45(@satellite_ode, t_span, initial_conditions, options);
    end

    function dydt = satellite_ode(~, y)
        G = 6.67430e-11;  % Gravitational constant
        M_earth = 5.972e24; % Mass of Earth
        r = y(1:3);
        v = y(4:6);
        r_norm = norm(r);
        acceleration = -(G * M_earth / r_norm^3) * r; % Gravitational acceleration
        dydt = [v; acceleration]; % Derivatives of position and velocity
    end
end
