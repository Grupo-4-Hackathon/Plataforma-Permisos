// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GestionUsuarios {
    address public owner;
    mapping(address => bool) public aprobadores;
    mapping(address => bool) public trabajadores;

    event AprobadorAsignado(address indexed aprobador);
    event AprobadorRevocado(address indexed aprobador);
    event TrabajadorRegistrado(address indexed trabajador);

    modifier onlyOwner() {
        require(msg.sender == owner, "Solo el propietario puede realizar esta accion");
        _;
    }

    modifier onlyAprobador() {
        require(aprobadores[msg.sender], "Solo un aprobador puede realizar esta accion");
        _;
    }

    modifier onlyTrabajador() {
        require(trabajadores[msg.sender], "Solo un trabajador puede realizar esta accion");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Registrar un nuevo aprobador (Solo el owner puede hacerlo)
    function asignarAprobador(address _aprobador) public onlyOwner {
        aprobadores[_aprobador] = true;
        emit AprobadorAsignado(_aprobador);
    }

    // Revocar aprobador (Solo el owner puede hacerlo)
    function revocarAprobador(address _aprobador) public onlyOwner {
        aprobadores[_aprobador] = false;
        emit AprobadorRevocado(_aprobador);
    }

    // Registrar un nuevo trabajador (Solo el owner puede hacerlo)
    function registrarTrabajador(address _trabajador) public onlyOwner {
        trabajadores[_trabajador] = true;
        emit TrabajadorRegistrado(_trabajador);
    }

    // Un trabajador puede solicitar permisos si está registrado
    function solicitarPermiso(address contratoPermiso, string memory fechaInicio, string memory fechaFin, string memory tipo) public onlyTrabajador {
        PermisoTrabajo(contratoPermiso).solicitarPermiso(msg.sender, fechaInicio, fechaFin, tipo);
    }

    // Un aprobador puede aprobar permisos
    function aprobarPermiso(address contratoPermiso, uint permisoId) public onlyAprobador {
        PermisoTrabajo(contratoPermiso).aprobarPermiso(permisoId);
    }

    // Un aprobador puede rechazar permisos
    function rechazarPermiso(address contratoPermiso, uint permisoId) public onlyAprobador {
        PermisoTrabajo(contratoPermiso).rechazarPermiso(permisoId);
    }
}

interface PermisoTrabajo {
    function solicitarPermiso(address idAprobador, string memory fechaInicio, string memory fechaFin, string memory tipo) external;
    function aprobarPermiso(uint id) external;
    function rechazarPermiso(uint id) external;
}
