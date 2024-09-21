import Web3 as web3
import json

gestion_usuarios_address = ''
contrato_permiso_address = ''

gestion_usuarios_abi = json.loads('')
permiso_abi = json.loads('')  

gestion_usuarios_contract = web3.eth.contract(address=gestion_usuarios_address, abi=gestion_usuarios_abi)

direccionOwner = web3.eth.accounts[0]

# Asignar un aprobador (solo el owner puede hacerlo)
def asignar_aprobador(direccionAprobador):
    tx_hash = gestion_usuarios_contract.functions.asignarAprobador(direccionAprobador).transact({
        'from': direccionOwner
    })
    receipt = web3.eth.waitForTransactionReceipt(tx_hash)
    print(f"Aprobador asignado en la transacción: {tx_hash.hex()}")

# Registrar un trabajador (solo el owner puede hacerlo)
def registrar_trabajador(direccionTrabajador):
    tx_hash = gestion_usuarios_contract.functions.registrarTrabajador(direccionTrabajador).transact({
        'from': direccionOwner
    })
    receipt = web3.eth.waitForTransactionReceipt(tx_hash)
    print(f"Trabajador registrado en la transacción: {tx_hash.hex()}")

# Solicitar un permiso (como trabajador)
def solicitar_permiso(direccionSolicitante, contrato_permiso_address, fecha_inicio, fecha_fin, tipo):
    tx_hash = gestion_usuarios_contract.functions.solicitarPermiso(contrato_permiso_address, fecha_inicio, fecha_fin, tipo).transact({
        'from': direccionSolicitante
    })
    receipt = web3.eth.waitForTransactionReceipt(tx_hash)
    print(f"Permiso solicitado en la transacción: {tx_hash.hex()}")

# Aprobador aprueba un permiso
def aprobar_permiso(direccionAprobador, contrato_permiso_address, permiso_id):
    tx_hash = gestion_usuarios_contract.functions.aprobarPermiso(contrato_permiso_address, permiso_id).transact({
        'from': direccionAprobador
    })
    receipt = web3.eth.waitForTransactionReceipt(tx_hash)
    print(f"Permiso aprobado en la transacción: {tx_hash.hex()}")


