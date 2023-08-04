function dqdt = attitude_dynamics(t, q, inertia, control_options, environmental_options)
    % Input:
    % - t: Current time (s)
    % - q: State vector containing quaternion (q(1:4)) and angular velocity (q(5:7))
    % - inertia: Inertia tensor of the satellite (kg*m^2)
    % - control_options: Struct containing flags and parameters for control systems
    % - environmental_options: Struct containing flags and parameters for environmental torques

    % Extract quaternion and angular velocity
    quaternion = q(1:4);
    omega = q(5:7);

    % Normalize quaternion
    quaternion = quaternion / norm(quaternion);

    % Compute control torques
    if control_options.reaction_wheels
        T_control = reaction_wheels(omega, control_options);
    elseif control_options.magnetic_torquers
        T_control = magnetic_torquers(omega, control_options);
    else
        T_control = zeros(3,1);
    end

    % Compute environmental torques
    T_environment = zeros(3,1);
    if environmental_options.gravity_gradient
        T_environment = T_environment + gravity_gradient_torque(quaternion, inertia);
    end
    if environmental_options.solar_radiation_pressure
        T_environment = T_environment + solar_radiation_torque(quaternion, environmental_options);
    end
    if environmental_options.aerodynamic
        T_environment = T_environment + aerodynamic_torque(quaternion, environmental_options);
    end

    % Total torque
    T_total = T_control + T_environment;

    % Compute angular acceleration
    omega_dot = inertia \ (T_total - cross(omega, inertia * omega));

    % Quaternion derivative
    quaternion_dot = 0.5 * [0, -omega'; omega, -skew_symmetric(omega)] * quaternion;

    % Concatenate results
    dqdt = [quaternion_dot; omega_dot];

    % Nested functions for different torques, etc. go here
    % ...
end

function S = skew_symmetric(v)
    S = [  0, -v(3),  v(2);
         v(3),    0, -v(1);
        -v(2),  v(1),    0];
end
