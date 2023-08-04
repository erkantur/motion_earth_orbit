function [t, y] = orbit_propagator(initial_conditions, t_span, integrator, gravitational_model, perturbations)
    % Input:
    % - initial_conditions: Initial state vector [position; velocity]
    % - t_span: Time span for the simulation
    % - integrator: String specifying the integration method ('RK4', 'Verlet', etc.)
    % - gravitational_model: String specifying the gravitational model ('point_mass', 'J2', etc.)
    % - perturbations: Struct containing flags for various perturbations (drag, SRP, etc.)

    switch integrator
        case 'RK4'
            [t, y] = rk4(@dynamics, t_span, initial_conditions);
        case 'Verlet'
            [t, y] = verlet(@dynamics, t_span, initial_conditions);
        % Add cases for other integrators as needed
    end

    function dydt = dynamics(t, y)
        % Extract position and velocity
        r = y(1:3);
        v = y(4:6);

        % Compute gravitational acceleration based on specified model
        switch gravitational_model
            case 'point_mass'
                acceleration = point_mass_gravity(r);
            case 'J2'
                acceleration = J2_gravity(r);
            % Add cases for other gravitational models as needed
        end

        % Apply perturbations
        if perturbations.drag
            acceleration = acceleration + atmospheric_drag(r, v);
        end
        if perturbations.solar_radiation_pressure
            acceleration = acceleration + solar_radiation_pressure(r);
        end

        dydt = [v; acceleration];
    end

    % Nested functions for different gravitational models, perturbations, etc. go here
    % Example:
    function a = point_mass_gravity(r)
        G = 6.67430e-11;
        M_earth = 5.972e24;
        a = -G * M_earth / norm(r)^3 * r;
    end

    % Define other nested functions for J2 gravity, atmospheric drag, solar radiation pressure, etc.
end

% The rk4 and verlet functions, as well as the nested functions for different gravitational models (e.g., J2_gravity) 
% and perturbations (e.g., atmospheric_drag, solar_radiation_pressure), 
% would need to be implemented separately, either within this file or in additional m-files.

