% Constants
G = 6.67430e-11;  % Gravitational constant (m^3 kg^-1 s^-2)
M_earth = 5.972e24; % Mass of Earth (kg)
R_earth = 6371e3;  % Radius of Earth (m)

% Initial Conditions (e.g., Geostationary Orbit)
r0 = [R_earth + 35786e3, 0, 0]; % Initial position (m)
v0 = [0, sqrt(G * M_earth / (R_earth + 35786e3)), 0]; % Initial velocity (m/s)
initial_conditions = [r0, v0];

% Time span (1 day)
t_span = [0, 24*3600];

% Solve the differential equation using ODE45
options = odeset('RelTol', 1e-9, 'AbsTol', 1e-10);
[t, y] = ode45(@satellite_ode, t_span, initial_conditions, options);

% Plot the orbit in 3D
figure
plot3(y(:,1), y(:,2), y(:,3), 'b-');
hold on
[xE, yE, zE] = sphere(50);
surf(R_earth*xE, R_earth*yE, R_earth*zE, 'FaceAlpha', 0.5, 'EdgeColor', 'none')
axis equal
xlabel('X (m)')
ylabel('Y (m)')
zlabel('Z (m)')
title('Satellite Orbit Around Earth')
grid on

% Differential Equation Function
function dydt = satellite_ode(~, y)
    G = 6.67430e-11;  % Gravitational constant
    M_earth = 5.972e24; % Mass of Earth
    r = y(1:3);
    v = y(4:6);
    r_norm = norm(r);
    acceleration = -(G * M_earth / r_norm^3) * r; % Gravitational acceleration
    dydt = [v; acceleration]; % Derivatives of position and velocity
end
