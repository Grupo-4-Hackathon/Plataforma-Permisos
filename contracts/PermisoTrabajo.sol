// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract PermisoTrabajo {
    uint public contadorPermisos = 0;

    struct Permiso {
        uint id;
        uint fechaSolicitud;
        address idSolicitante;  // Cambiado a address
        address idAprobador;    // Cambiado a address
        string fechaInicio;
        string fechaFin;
        string tipo;
        string estado;
        bool tramitado;
    }

    mapping(uint => Permiso) public permisos;

    event PermisoSolicitado(
        uint id,
        uint fechaSolicitud,
        address idSolicitante,   // address corregido
        address idAprobador,
        string estado,
        bool tramitado
    );

    event PermisoAprobado(
        uint id,
        string estado,
        bool tramitado
    );

    event PermisoRechazado(
        uint id,
        string estado
    );

    event PermisoTramitado(
        uint id,
        string estado,
        bool tramitado
    );

    event PermisoModificado(
        uint id
    );

    /*
    constructor(address _idAprobador, string memory _fechaInicio, string memory _fechaFin, string memory _tipo) {
        solicitarPermiso(_idAprobador, _fechaInicio, _fechaFin, _tipo);
    }*/

    // Solicitar un nuevo permiso
    function solicitarPermiso(address idAprobador, string memory fechaInicio, string memory fechaFin, string memory tipo) public {
        contadorPermisos++;
        uint fechaSolicitud = block.timestamp;
        address idSolicitante = msg.sender;

        permisos[contadorPermisos] = Permiso(
            contadorPermisos,
            fechaSolicitud,
            idSolicitante,
            idAprobador,
            fechaInicio,
            fechaFin,
            tipo,
            "Pendiente",
            false
        );

        emit PermisoSolicitado(contadorPermisos, fechaSolicitud, idSolicitante, idAprobador, "Pendiente", false);
    }

    // Cambiar el estado de un permiso a completado/tramitado
    function permisoTramitado(uint _id) public {
        Permiso storage permiso = permisos[_id];  // Cambiado a storage para modificar en lugar de copiar

        // Solo el aprobador puede marcar como tramitado
        require(msg.sender == permiso.idAprobador, "Solo el aprobador puede completar el permiso");

        permiso.tramitado = !permiso.tramitado;

        if (permiso.tramitado) {
            permiso.estado = "Aprobado";
            emit PermisoTramitado(_id, "Aprobado", true);
        } else {
            permiso.estado = "Pendiente";
            emit PermisoTramitado(_id, "Pendiente", false);
        }
    }

    // Aprobar un permiso
    function aprobarPermiso(uint _id) public {
        Permiso storage permiso = permisos[_id];

        // Solo el aprobador puede aprobar
        require(msg.sender == permiso.idAprobador, "Solo el aprobador puede aprobar");

        permiso.estado = "Aprobado";
        permiso.tramitado = true;
        emit PermisoAprobado(_id, "Aprobado", true);
    }

    // Rechazar un permiso
    function rechazarPermiso(uint _id) public {
        Permiso storage permiso = permisos[_id];

        // Solo el aprobador puede rechazar
        require(msg.sender == permiso.idAprobador, "Solo el aprobador puede rechazar");

        permiso.estado = "Rechazado";
        emit PermisoRechazado(_id, "Rechazado");
    }

    // Modificar un permiso
    function modificarPermiso(uint _id, string memory _fechaInicio, string memory _fechaFin, string memory _tipo) public {
        Permiso storage permiso = permisos[_id];

        // Solo el solicitante puede modificar su propio permiso
        require(msg.sender == permiso.idSolicitante, "Solo el solicitante puede modificar el permiso");

        permiso.fechaInicio = _fechaInicio;
        permiso.fechaFin = _fechaFin;
        permiso.tipo = _tipo;

        emit PermisoModificado(_id);
    }
}

