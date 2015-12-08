package pecl2;

import java.util.Hashtable;

public class Identificador {

	private String nombre;
	private String tipo;

	public Identificador(String nombre, String tipo) {
		this.nombre = nombre;
		this.tipo = tipo;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	Hashtable <String, Identificador> m =new Hashtable<String, Identificador>();
	

}
