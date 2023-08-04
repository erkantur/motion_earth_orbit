function properties = earth_model(r, model_options)
    % Input:
    % - r: Position vector of the satellite in ECEF or geodetic coordinates
    % - model_options: Struct containing flags and parameters for different models

    properties = struct();

    % Gravity field
    if model_options.gravity_field
        switch model_options.gravity_model
            case 'point_mass'
                properties.gravity = point_mass_gravity(r);
            case 'J2'
                properties.gravity = J2_gravity(r);
            case 'spherical_harmonics'
                properties.gravity = spherical_harmonics_gravity(r, model_options.spherical_harmonics_order);
        end
    end

    % Atmospheric properties
    if model_options.atmosphere
        properties.atmospheric_density = atmospheric_density(r);
        properties.wind = wind_model(r);
    end

    % Earth's magnetic field
    if model_options.magnetic_field
        properties.magnetic_field = magnetic_field(r);
    end

    % Nested functions for different models
    function g = point_mass_gravity(r)
        G = 6.67430e-11;
        M_earth = 5.972e24;
        g = -G * M_earth / norm(r)^3 * r;
    end

    function g = J2_gravity(r)
        % Code to include J2 perturbation
        % ...
    end

    function g = spherical_harmonics_gravity(r, order)
        % Code to include spherical harmonics up to specified order
        % ...
    end

    function rho = atmospheric_density(r)
        % Code to calculate atmospheric density based on altitude, latitude, etc.
        % ...
    end

    function w = wind_model(r)
        % Code to model wind at a given location
        % ...
    end

    function B = magnetic_field(r)
        % Code to calculate Earth's magnetic field at a given location
        % ...
    end
end
