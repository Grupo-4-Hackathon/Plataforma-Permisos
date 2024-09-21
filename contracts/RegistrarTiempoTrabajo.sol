 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RegistroTiempoTrabajo {

    struct RegistroDiario {
        uint timestamp_entrada;        // Hora de entrada (timestamp)
        uint timestamp_salida;         // Hora de salida (timestamp)
        uint horasTrabajadas;          // Total de horas trabajadas en ese día (en horas)
    }

    // Mapeo de trabajadores y sus registros diarios, utilizando fecha en formato "dd/mm/yyyy" como clave.
    mapping (address => mapping(string => RegistroDiario)) public registros;

    // Eventos
    event HoraIngresoRegistrada(address indexed trabajador, string indexed fecha, uint timestamp);
    event HoraSalidaRegistrada(address indexed trabajador, string indexed fecha, uint timestamp);
    event HorasTrabajadasRegistradas(address indexed trabajador, string indexed fecha, uint horasTrabajadas);

    /**
     * @dev Registra la hora de entrada del trabajador para una fecha específica.
     * @param _fecha La fecha en formato "dd/mm/yyyy" en la que se quiere registrar la entrada.
     */
    function registrarIngreso(string memory _fecha) public {
        // Asegurarse de que la entrada no haya sido registrada previamente para esa fecha
        require(registros[msg.sender][_fecha].timestamp_entrada == 0, "El ingreso ya fue registrado para esta fecha");

        // Registrar la hora de entrada
        registros[msg.sender][_fecha].timestamp_entrada = block.timestamp;

        // Emitir el evento de hora de ingreso
        emit HoraIngresoRegistrada(msg.sender, _fecha, block.timestamp);
    }

    /**
     * @dev Registra la hora de salida del trabajador para una fecha específica y calcula las horas trabajadas.
     * @param _fecha La fecha en formato "dd/mm/yyyy" en la que se quiere registrar la salida.
     */
    function registrarSalida(string memory _fecha) public {
        RegistroDiario storage registro = registros[msg.sender][_fecha];

        // Verificar que se haya registrado una entrada previa en esa fecha
        require(registro.timestamp_entrada != 0, "No se ha registrado la hora de entrada para esta fecha");

        // Verificar que no se haya registrado ya una salida en esa fecha
        require(registro.timestamp_salida == 0, "La salida ya fue registrada para esta fecha");

        // Registrar la hora de salida
        registro.timestamp_salida = block.timestamp;

        // Calcular las horas trabajadas (en horas)
        registro.horasTrabajadas = (registro.timestamp_salida - registro.timestamp_entrada) / 3600;

        // Emitir eventos correspondientes
        emit HoraSalidaRegistrada(msg.sender, _fecha, block.timestamp);
        emit HorasTrabajadasRegistradas(msg.sender, _fecha, registro.horasTrabajadas);
    }

    /**
     * @dev Obtiene el total de horas trabajadas en una fecha específica.
     * @param _fecha La fecha en formato "dd/mm/yyyy" de la cual se quieren obtener las horas trabajadas.
     * @return uint El número de horas trabajadas.
     */
    function obtenerHorasTrabajadas(string memory _fecha) public view returns (uint) {
        RegistroDiario storage registro = registros[msg.sender][_fecha];

        // Verificar que la jornada haya terminado (es decir, que se haya registrado una salida)
        require(registro.timestamp_salida != 0, "La jornada no ha terminado en esta fecha");

        // Retornar las horas trabajadas
        return registro.horasTrabajadas;
    }
}
