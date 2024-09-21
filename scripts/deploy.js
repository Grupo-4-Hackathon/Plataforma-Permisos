const hre = require("hardhat");

async function main() {
    const GestionUsuarios = await hre.ethers.getContractFactory("GestionUsuarios");
    const gestionUsuarios = await GestionUsuarios.deploy();

    // Esperar a que el contrato sea desplegado
    await gestionUsuarios.waitForDeployment();

    // Obtener la dirección usando getAddress()
    const contractAddress = await gestionUsuarios.getAddress();
    console.log("GestionUsuarios desplegado en:", contractAddress);

    const PermisoTrabajo = await hre.ethers.getContractFactory("contracts/PermisoTrabajo.sol:PermisoTrabajo");
    const permisoTrabajo = await PermisoTrabajo.deploy();

    // Esperar a que el contrato sea desplegado
    await permisoTrabajo.waitForDeployment();

    // Obtener la dirección usando getAddress()
    const contractAddress_permiso = await permisoTrabajo.getAddress();
    console.log("PermisoTrabajo desplegado en:", contractAddress_permiso);

}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
