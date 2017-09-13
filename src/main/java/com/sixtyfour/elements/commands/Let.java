/*
 * 
 */
package com.sixtyfour.elements.commands;

import java.util.ArrayList;
import java.util.List;

import com.sixtyfour.cbmnative.NativeCompiler;
import com.sixtyfour.elements.Type;
import com.sixtyfour.elements.Variable;
import com.sixtyfour.parser.Atom;
import com.sixtyfour.parser.Parser;
import com.sixtyfour.parser.Term;
import com.sixtyfour.parser.VariableAndIndex;
import com.sixtyfour.parser.cbmnative.CodeContainer;
import com.sixtyfour.system.BasicProgramCounter;
import com.sixtyfour.system.Machine;
import com.sixtyfour.util.VarUtils;

/**
 * The LET command.
 */
public class Let extends AbstractCommand {

	/** The var. */
	private Variable var;

	/** The index term. */
	private Term indexTerm;

	private List<Atom> pars;

	private int[] pis;

	/**
	 * Instantiates a new let.
	 */
	public Let() {
		super("LET");
	}

	/**
	 * Gets the var.
	 * 
	 * @return the var
	 */
	public Variable getVar() {
		return var;
	}

	/**
	 * Sets the var.
	 * 
	 * @param var
	 *            the new var
	 */
	public void setVar(Variable var) {
		this.var = var;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see sixtyfour.elements.commands.AbstractCommand#getType()
	 */
	@Override
	public Type getType() {
		return var.getType();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see sixtyfour.elements.commands.AbstractCommand#parse(java.lang.String,
	 * int, int, int, boolean, sixtyfour.system.Machine)
	 */
	@Override
	public String parse(String linePart, int lineCnt, int lineNumber, int linePos, boolean lastPos, Machine machine) {
		super.parse(linePart, lineCnt, lineNumber, linePos, lastPos, machine);
		if (VarUtils.toUpper(linePart).startsWith("LET")) {
			linePart = linePart.substring(3).trim();
		}
		var = Parser.getVariable(linePart, machine);
		VariableAndIndex vai = Parser.getIndexTerm(var, linePart, machine, true);
		indexTerm = vai.getIndexTerm();
		var = vai.getVariable();
		term = Parser.getTerm(linePart, machine, true, true);
		if (term.getOperator().isDelimiter()) {
			syntaxError(linePart);
		}
		if (!var.getType().equals(term.getType()) && (var.getType().equals(Type.STRING) || term.getType().equals(Type.STRING))) {
			typeMismatch(linePart);
		}
		if (indexTerm != null) {
			pars = Parser.getParameters(indexTerm);
			pis = new int[pars.size()];
		}
		return null;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * sixtyfour.elements.commands.AbstractCommand#execute(sixtyfour.system.
	 * Machine)
	 */
	@Override
	public BasicProgramCounter execute(Machine machine) {
		var = machine.add(var);
		if (indexTerm == null) {
			// no array
			var.setValue(term.eval(machine));
		} else {
			// array
			for (int i = 0; i < pars.size(); i++) {
				pis[i] = VarUtils.getInt(pars.get(i).eval(machine));
			}
			var.setValue(term.eval(machine), pis);
		}
		return null;
	}

	@Override
	public List<CodeContainer> evalToCode(Machine machine) {
		var = machine.add(var);
		NativeCompiler compiler = NativeCompiler.getCompiler();
		List<String> after = new ArrayList<String>();
		List<String> expr = compiler.compileToPseudoCode(machine, term);
		List<String> before = null;

		String expPush = getPushRegister(expr.get(expr.size() - 1));
		expr = expr.subList(0, expr.size() - 1); // Remove trailing PUSH X/PUSH
													// A

		if (indexTerm != null) {
			before = compiler.compileToPseudoCode(machine, Parser.createIndexTerm(machine, pars, var.getDimensions()));
			if (expPush.equals("X")) {
				after.add("MOV Y,X");
			} else if (expPush.equals("B")) {
				after.add("MOV A,B");
			}
			after.add("POP X");
			after.add("MOV G," + getVariableLabel(machine, var));
			after.add("JSR ARRAYSTORE");
		} else {
			after.add("MOV " + getVariableLabel(machine, var) + "," + expPush);
		}

		CodeContainer cc = new CodeContainer(before, expr, after);
		List<CodeContainer> ccs = new ArrayList<CodeContainer>();
		ccs.add(cc);
		return ccs;
	}
}
