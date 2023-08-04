function F_solar = solar_radiation(satellite_position, sun_position, satellite_properties)
    % Input:
    % - satellite_position: Position of the satellite in ECEF or ECI coordinates (m)
    % - sun_position: Position of the sun in ECEF or ECI coordinates (m)
    % - satellite_properties: Struct containing properties of the satellite (mass, area, reflectivity, etc.)

    % Constants
    P_sun = 1361; % Solar constant, radiation pressure at 1 AU from Sun (W/m^2)
    AU = 1.496e11; % Astronomical Unit in meters
    c = 3e8; % Speed of light in m/s

    % Compute the vector from the satellite to the Sun
    r_sat_sun = sun_position - satellite_position;
    distance_to_sun = norm(r_sat_sun);
    unit_r_sat_sun = r_sat_sun / distance_to_sun;

    % Check if the satellite is in the Earth's shadow
    if in_earth_shadow(satellite_position, sun_position)
        F_solar = zeros(3, 1);
        return;
    end

    % Compute the apparent solar radiation pressure at the satellite's distance
    P_apparent = P_sun * (AU / distance_to_sun)^2;

    % Compute force due to solar radiation pressure
    F_solar = satellite_properties.area * P_apparent / c * ...
              (satellite_properties.reflectivity * unit_r_sat_sun + ...
               (1 - satellite_properties.absorptivity) * ...
               satellite_properties.normal_vector); % Adjust according to satellite's surface normal

    % Nested function for Earth shadow check
    function shadow = in_earth_shadow(satellite_position, sun_position)
        % Implement a model to determine if the satellite is in the Earth's shadow
        % This could include penumbra and umbra calculations
        % ...
    end
end
