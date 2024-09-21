const hre = require("hardhat");

async function main() {
    const GestionUsuarios = await hre.ethers.getContractFactory("GestionUsuarios");
    const gestionUsuarios = await GestionUsuarios.deploy();
    await gestionUsuarios.deployed();
    console.log("GestionUsuarios desplegado en:", gestionUsuarios.address);

    const PermisoTrabajo = await hre.ethers.getContractFactory("PermisoTrabajo");
    const permisoTrabajo = await PermisoTrabajo.deploy();
    await permisoTrabajo.deployed();
    console.log("PermisoTrabajo desplegado en:", permisoTrabajo.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
