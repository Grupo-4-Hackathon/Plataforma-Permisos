import web3
import json

gestion_usuarios_address = '0x4558FD325d2F03832e0F233857000cD76E442111'
contrato_permiso_address = '0xc8d4a27811733e294B99f567910983C355d520DB'

with open("./artifacts/contracts/GestionUsuarios.sol/GestionUsuarios.json","r") as file1:
    gestion_usuarios_abi = json.load(file1)

with open("./artifacts/contracts/PermisoTrabajo.sol/PermisoTrabajo.json","r") as file2:
    permiso_trabajo_abi = json.load(file2)

 
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


