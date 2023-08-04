function [control_output, controller_state] = control_systems(t, reference, state, parameters, controller_state)
    % Input:
    % - t: Current time (s)
    % - reference: Reference trajectory or set-point
    % - state: Current state of the system (position, velocity, attitude, etc.)
    % - parameters: Struct containing parameters and options for the control system
    % - controller_state: Struct containing the previous state of the controller (for stateful controllers like PID)

    % Initialize control output
    control_output = struct();

    % Attitude control
    if parameters.attitude_control.enabled
        [control_output.attitude, controller_state.attitude] = attitude_controller(reference.attitude, state.attitude, parameters.attitude_control, controller_state.attitude);
    end

    % Orbit control
    if parameters.orbit_control.enabled
        [control_output.orbit, controller_state.orbit] = orbit_controller(reference.orbit, state.orbit, parameters.orbit_control, controller_state.orbit);
    end

    % Thermal control
    if parameters.thermal_control.enabled
        control_output.thermal = thermal_controller(state.temperature, parameters.thermal_control);
    end

    % Power control
    if parameters.power_control.enabled
        control_output.power = power_controller(state.power, parameters.power_control);
    end

    % Nested functions for different controllers
    function [u, controller_state] = attitude_controller(reference, state, parameters, controller_state)
        % Implementation of attitude controller (e.g., PID, LQR, etc.)
        % This could include reaction wheel control, magnetic torquer control, etc.
    end

    function [u, controller_state] = orbit_controller(reference, state, parameters, controller_state)
        % Implementation of orbit controller (e.g., thruster control)
    end

    function u = thermal_controller(state, parameters)
        % Implementation of thermal control (e.g., active cooling, heaters)
    end

    function u = power_controller(state, parameters)
        % Implementation of power control (e.g., solar panel orientation, battery management)
    end
end
