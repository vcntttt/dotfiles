# 1) Habilita IP forwarding si no lo has hecho:
sudo sysctl -w net.ipv4.ip_forward=1

# 2) Regla de masquerade para que tu red 192.168.56.0/24 salga por cualquier interfaz 
#    excepto virbr0 y use la IP pública de tu host:
sudo iptables -t nat -A POSTROUTING -s 192.168.56.0/24 ! -o virbr0 -j MASQUERADE

# 3) Permite el forwarding de paquetes ENTRANTES y SALIENTES por virbr0:
sudo iptables -I FORWARD -i virbr0 -j ACCEPT
sudo iptables -I FORWARD -o virbr0 -j ACCEPT

