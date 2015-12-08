package pecl2;

import java.util.ArrayList;

public class Funcion {

	private String nombre;
	private int aridad;
	private ArrayList<Identificador> entrada;
	private String salida;

	public Funcion(String nombre, ArrayList<Identificador> entrada, String salida) {
		this.nombre = nombre;
		this.entrada = entrada;
		this.salida = salida;
		this.aridad = entrada.size();
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public int getAridad() {
		return aridad;
	}

	public void setAridad(int aridad) {
		this.aridad = aridad;
	}

	public ArrayList<Identificador> getEntrada() {
		return entrada;
	}

	public void setEntrada(ArrayList<Identificador> entrada) {
		this.entrada = entrada;
	}

	public String getSalida() {
		return salida;
	}

	public void setSalida(String salida) {
		this.salida = salida;
	}
}
