# lolminer-container
Docker image to run LolMiner locally or on cloud platforms such as Vast.ai\

Variables that need to be specificed in Docker to run 
POOL = Stratum Pool
WALLET = Wallet Address 
ALGO = Mining algorithm. See lolMiner https://github.com/Lolliedieb/lolMiner-releases/releases.

Example docker run ```docker run --rm -it --gpus all -e POOL="<pool address>" -e WALLET="<wallet>"  -e ALGO="<algo for XTM SHA3x or CR29>" vast-lolminer:1.98```
