/*
 *    Author: Yitao Li
 *
 *    IMPORTANT: to compile this program:
 *                  
 *                 rm -f MiniJavaV3*.java
 *                 java -jar <path of antlr-4.1-complete.jar> MiniJavaV3.g4
 *                 javac -cp <path of antlr-4.1-complete.jar>:. MiniJavaV3*.java
 *
 *                 (this should work in any UNIX operating system)
 *
 *                 (or possibly replace "rm" with "del" and use ";" as path separator in 
 *                  a non-POSIX operating system (e.g., MS Windows))
 *
 *
 *               to run this program:
 *                 
 *                 java -cp <path of antlr-4.1-complete.jar>:. MiniJavaV3Parser <Java src file>
 *
 *                 (the main function that is compiled and executed should be the one
 *                  specified in this .g4 file not the default ANTLR version) 
 *
 *
 *               extra credit attempted: all
 *
 *
 */ 

grammar MiniJavaV3;

@header {

import java.util.LinkedList;
import java.util.Stack;
import java.util.Map;
import java.util.HashSet;
import java.util.HashMap;
import java.util.Iterator;

}

@members {

	enum VarType {
		BOOLEAN, INT, STRING, VOID, OBJECT, UNKNOWN
	}

	enum FactorOp {
		NONE, AND, MULT, DIV
	}

	enum TermOp {
		NONE, OR, ADD, SUB
	}

	class SemInfo {

		public final int offset;

		public final VarType type;	

		public final String clsName;   /* should be NULL for primitive type and be otherwise equal to the formal type of the non-primitive type */

		public SemInfo(final VarType type, final int offset, final String clsName) {
			this.type = type;
			this.offset = offset;
			this.clsName = (this.type == VarType.OBJECT ? clsName : null);
		}

	}

	class Ops {

		public final FactorOp factorOp;

		public final TermOp termOp;

		public Ops(final FactorOp factorOp, final TermOp termOp) {
			this.factorOp = factorOp;
			this.termOp = termOp;
		}

	}

	class MethodSemInfo {

		private int vmtOffset = 0;

		public final SemInfo returnType;

		public final LinkedList<SemInfo> paramList;

		public MethodSemInfo(final SemInfo returnType, final LinkedList<SemInfo> paramList) {
			this.returnType = returnType;
			this.paramList = paramList;
		}

		public MethodSemInfo(final int vmtOffset, final SemInfo returnType, final LinkedList<SemInfo> paramList) {
			this.vmtOffset = vmtOffset;
			this.returnType = returnType;
			this.paramList = paramList;
		}

		public void setVmtOffset(final int vmtOffset) {
			this.vmtOffset = vmtOffset;
		}

	}
		
	class MethodCall {

		public final int vmtOffset; 

		public final int numParam;

		public final String objType;

		public final VarType returnType;

		public MethodCall(final int vmtOffset, final int numParam, final VarType returnType) {
			this.vmtOffset = vmtOffset;
			this.numParam = numParam;
			this.returnType = returnType;
			this.objType = null;
		}

		public MethodCall(final int vmtOffset, final int numParam, final String objType) {
			this.vmtOffset = vmtOffset;
			this.numParam = numParam;
			this.objType = objType;
			this.returnType = VarType.OBJECT;
		}

	}

	private boolean processDecl;  /* process method declarations, class declarations */

	private boolean postProcessDecl;   /* process method return types, field declarations, etc */

	private boolean declProcessed;

	private boolean thisMethodCall;

	private int numLabel = 0;

	private int currentEval = 0;

	private int nextEvalOffset;  /* next offset available for arithematic operation */

	private int class_offset = /*1*/0;

	private int method_offset = 1;  /* total amount of stack space used -- reserving 1 byte for implicit "this" */

	private int fp_save_offset = 0;  /* offset in current method for saving the frame pointer */

	private int numStringLiteral = 0;  /* number of string literal(s) in source code */

	private String currentClassName = null;

	private String currentObjType = null;

	private String currentMethodParamListStr = "";

	private String loadParam = "";

	private VarType exprType = VarType.UNKNOWN;

	private LinkedList<SemInfo> currentMethodParamList = null;

	private final Stack<FactorOp> FactorOpStack = new Stack<FactorOp>();

	private final Stack<TermOp> TermOpStack = new Stack<TermOp>();

	private final Stack<FactorOp> CondFactorOpStack = new Stack<FactorOp>();

	private final Stack<TermOp> CondTermOpStack = new Stack<TermOp>();

	private HashMap<String, SemInfo> currentClassMethodDecls;

	private HashMap<String, LinkedList<MethodSemInfo>> currentClassMethodParamListMap;

	private HashMap<String, SemInfo> classSymbolTable;

	private final HashMap<String, SemInfo> methodSymbolTable = new HashMap<String, SemInfo>();

	private final HashMap<Integer, Integer> methodOffsetTable = new HashMap<Integer, Integer>();

	private final HashMap<String, Integer> strTable = new HashMap<String, Integer>();

	private final Iterator<MethodCall> methodCallIter = methodCall.iterator(); 

	private static boolean err = false;

	private static final int numTempSave = 8;    /* save and restore temp registers between method calls */

	private static final Boolean printComment = true;

	private static final String NULL_TYPE = "null";

	private static final String SS_prefix = ".stack_size_of_";

	private static final String spSave = ".spSave";

	private static final String fpSave = ".fpSave";

	private static final String VMT_suffix = ".VMT";

	private static final String str = ".str";
	
	private static String data = spSave + ":  .word  0\n" + fpSave + ":  .word  0\n"; 

	private static final String StrLibText = "\n.stringConcat:\n\tsw\t\$ra\t.concatRegSave\n\tsw\t\$a0,\t.concatFirStr\n\tsw\t\$a1,\t.concatSecStr\n\n\n\tjal\t.stringLength\n\tsw\t\$v0\t.concatFirStrLen\t\n\t\t\n\tlw\t\$a0\t.concatSecStr\t\n\tjal\t.stringLength\n\tsw\t\$v0\t.concatSecStrLen\t\n\n\n\tli\t\$v0\t9\n\tlw\t\$t0\t.concatFirStrLen\n\tlw\t\$t1\t.concatSecStrLen\n\tadd\t\$a0\t\$t0\t\$t1\n\taddi\t\$a0\t\$a0\t1\n\tsyscall\n\tsw\t\$v0\t.concatNewStr\n\tmove\t\$t4\t\$v0\n\n\n\tmove\t\$t1\t\$zero\n\tlw\t\$s2\t.concatFirStr\n\n.concatTop1:\tlb\t\$t1\t0(\$s2)\n\tbeq\t\$t1\t\$zero\t.doneConcatFirst\n\tsb\t\$t1\t0(\$t4)\n\taddi\t\$s2\t\$s2\t1\n\taddi\t\$t4\t\$t4\t1\n\tj\t.concatTop1\n\n.doneConcatFirst:\t\n\tlw\t\$s0\t.concatSecStr\n\n.concatTop2:\tlb\t\$t1\t0(\$s0)\n\tbeq\t\$t1\t\$zero\t.doneConcatSecond\n\tsb\t\$t1\t0(\$t4)\n\taddi\t\$s0\t\$s0\t1\n\taddi\t\$t4\t\$t4\t1\n\tj\t.concatTop2\n\n.doneConcatSecond:\t\n\n\tsb\t\$zero\t0(\$t4)\n\t\n\tlw\t\$ra\t.concatRegSave\n\tlw\t\$a0\t.concatFirStr\n\tlw\t\$a1\t.concatSecStr\n\tlw\t\$v0\t.concatNewStr\t\n\tjr\t\$ra\n\n.stringLength:\n\tmove\t\$t0\t\$zero\n\tmove\t\$t2\t\$zero\n\tmove\t\$t1\t\$a0\n\n.lengthLoop:\n\tlb\t\$t2\t0(\$t1)\t\n\tbeq\t\$t2\t\$zero\t.doneCountLength\n\taddi\t\$t0\t\$t0\t1\n\taddi\t\$t1\t\$t1\t1\n\tj\t.lengthLoop\n\n.doneCountLength:\n\tmove\t\$v0\t\$t0\n\tjr\t\$ra\n";

	private static final String StrLibData = ".concatFirStr:\t.word\t0\n.concatSecStr:\t.word\t0\n.concatFirStrLen:\t.word\t0\n.concatSecStrLen:\t.word\t0\n.concatNewStr:\t.word\t0\n.concatRegSave:\t.word\t0\n";

	private static final LinkedList<MethodCall> methodCall = new LinkedList<MethodCall>();

	private static final HashMap<String, Integer> objSizeTable = new HashMap<String, Integer>();

	private static final HashMap<String, String> extTable = new HashMap<String, String>();   /* <sub-class, super-class> */

	private static final HashMap< String, HashMap<String, SemInfo> > methodDeclTable = new HashMap< String, HashMap<String, SemInfo> >();

	private static final HashMap<String, HashMap<String, LinkedList<MethodSemInfo>>> methodSemInfoTable = new HashMap<String, HashMap<String, LinkedList<MethodSemInfo>>>(); 

	private static final HashMap<String, HashMap<String, SemInfo>> classTable = new HashMap<String, HashMap<String, SemInfo>>(); 

	private int getField(final String clsName, final String fieldName, final SemInfo sinfo[]) {   /* returns abs. offset plus SemInfo of a field */
		String currentClsName = clsName, parentClsName = extTable.get(currentClsName);
		HashMap<String, SemInfo> currentClsTable = classTable.get(currentClsName);
		while (!currentClsTable.containsKey(fieldName)) {
			if (parentClsName == null) {
				sinfo[0] = null;
				return -1;
			}
			currentClsName = parentClsName; 
			currentClsTable = classTable.get(currentClsName);
			parentClsName = extTable.get(currentClsName);
		}
		sinfo[0] = currentClsTable.get(fieldName);
		return (parentClsName == null ? 1 : 1 + getObjSize(parentClsName)) + sinfo[0].offset;
	}

	private VarType getIdType(final String id) {
		final SemInfo sinfo = methodSymbolTable.get(id);
		SemInfo field_sinfo[];
		if (sinfo != null) {
			return sinfo.type;
		}
		field_sinfo = new SemInfo[1];
		getField(currentClassName, id, field_sinfo); 
		if (field_sinfo[0] != null) {
			return field_sinfo[0].type;
		}
		return VarType.UNKNOWN;
	}

	private VarType getIdType(final String id, final String clsName) {
		final SemInfo field_sinfo[] = new SemInfo[1];
		getField(clsName, id, field_sinfo); 
		return field_sinfo[0].type;
	}

	private boolean isA(final String currentClsName, final String supClsName) {
		String cls = currentClsName;
		if (cls.equals(NULL_TYPE)) {
			return true;
		}
		while (!cls.equals(supClsName)) {
			cls = extTable.get(cls);
			if (cls == null) {
				return false;
			}
		}
		return true;
	}

	private boolean isCompatible(final SemInfo sinfoA, final SemInfo sinfoB) {
		return (sinfoA.type == VarType.OBJECT && sinfoB.type == VarType.OBJECT && isA(sinfoA.clsName, sinfoB.clsName)) || (sinfoA.type != VarType.OBJECT && sinfoA.type == sinfoB.type);
	}

	private boolean isSubSignature(final LinkedList<SemInfo> sgnA, final LinkedList<SemInfo> sgnB) {
		final Iterator<SemInfo> iterA = sgnA.iterator();
		final Iterator<SemInfo> iterB = sgnB.iterator();
		while (iterA.hasNext() && iterB.hasNext()) {
			SemInfo sinfoA = iterA.next();
			SemInfo sinfoB = iterB.next();
			if (!isCompatible(sinfoA, sinfoB)) {
				return false;
			}
		}
		if (iterA.hasNext() || iterB.hasNext()) {   /* the lengths of the parameter lists differ */
			return false;
		}
		return true;
	}

	private String getObjectVarClsName(final String varName) {
		final SemInfo sinfo = methodSymbolTable.get(varName), field_sinfo[]; 
		if (sinfo == null) {
			field_sinfo = new SemInfo[1];
			getField(currentClassName, varName, field_sinfo); 
			return field_sinfo[0].clsName;
		}
		return sinfo.clsName;
	}

	private String getObjectVarClsName(final String varName, final String clsName) {
		final SemInfo field_sinfo[] = new SemInfo[1];
		getField(clsName, varName, field_sinfo); 
		return field_sinfo[0].clsName;
	}

	private int getObjSize(final String cls) {    /* NOTE: not including the reserved 1st byte reserved for the VMT address */
		int size = classTable.get(cls).size();
		String __cls = extTable.get(cls);
		while (__cls != null) {
			size += classTable.get(__cls).size();
			__cls = extTable.get(__cls);
		}
		return size; 
	}

	private VarType getVarType(final String type) {
		return type.equals("boolean") ? VarType.BOOLEAN : type.equals("int") ? VarType.INT : type.equals("String") ? VarType.STRING : type.equals("void") ? VarType.VOID : classTable.containsKey(type) ? VarType.OBJECT : VarType.UNKNOWN;
	}

	private String getVarTypeStr(final VarType type) {
		return type == VarType.BOOLEAN ? "boolean" : type == VarType.INT ? "int" : type == VarType.STRING ? "String": type == VarType.VOID ? "void" : null;
	}

	private String methodParamListToString(final String methodName, final LinkedList<SemInfo> paramList) {
		String ret = methodName;
		final Iterator<SemInfo> iter = paramList.iterator();
		while (iter.hasNext()) {
			SemInfo param = iter.next();
			ret += "." + (param.type == VarType.OBJECT ? param.clsName : getVarTypeStr(param.type)); 
		}
		return ret;
	}

	private void generateVMT(final String clsName) {
		/* note: VMT labels need to have both prefix "." and suffix ".VMT" to be distinguished from other internal labels
		   (e.g. ".print_boolean", etc, and no other labels should have both "." prefix and ".VMT" suffix)
		*/
		int vmtOffset = 0;
		String vmt = "\n\tsw\t\$t0,\t." + clsName + VMT_suffix;
		String parentClsName = extTable.get(clsName);
		final HashMap<String, SemInfo> methodDecls = methodDeclTable.get(clsName);
		final HashMap<String, LinkedList<MethodSemInfo>> methodParamListMap = methodSemInfoTable.get(clsName);
		data += "." + clsName + VMT_suffix + " :  .word  0\n";
		if (printComment) {
			vmt += "\n# VMT for class " + clsName + "\n";
		}
		for (final Map.Entry<String, LinkedList<MethodSemInfo>> method : methodParamListMap.entrySet()) {
			for (final MethodSemInfo currentMethodSemInfo : method.getValue()) {
				vmt += "\tla\t\$t1,\t" + clsName + "." + methodParamListToString(method.getKey(), currentMethodSemInfo.paramList) + "\n" + "\tsw\t\$t1,\t" + (vmtOffset << 2) + "(\$t0)\n"; 
				currentMethodSemInfo.setVmtOffset(vmtOffset++);
			}
		}

		while (parentClsName != null) { 
			final HashMap<String, SemInfo> inheritedMethodDecls = methodDeclTable.get(parentClsName);
			final HashMap<String, LinkedList<MethodSemInfo>> parentMethodParsmLists = methodSemInfoTable.get(parentClsName);
			for (final Map.Entry<String, LinkedList<MethodSemInfo>> method : parentMethodParsmLists.entrySet()) {
				String methodName = method.getKey();
				LinkedList<MethodSemInfo> parentMethodParamList = method.getValue();  
				for (final MethodSemInfo methodSemInfo : parentMethodParamList) {
					String methodDeclStr = methodParamListToString(methodName, methodSemInfo.paramList);
					if (inheritedMethodDecls.containsKey(methodDeclStr)) {
						if (!methodDecls.containsKey(methodDeclStr)) {
							LinkedList<MethodSemInfo> methodParamLists;
							vmt += "\tla\t\$t1,\t" + parentClsName + "." + methodDeclStr + "\n" + "\tsw\t\$t1,\t" + (vmtOffset << 2) + "(\$t0)\n"; 
							if (!methodParamListMap.containsKey(methodName)) {
								methodParamLists = new LinkedList<MethodSemInfo>();
								methodParamListMap.put(methodName, methodParamLists);
							}else {
								methodParamLists = methodParamListMap.get(methodName);
							}
							methodParamLists.add(new MethodSemInfo(vmtOffset++, methodSemInfo.returnType, methodSemInfo.paramList));
						}else {
							SemInfo currentReturnType = methodDecls.get(methodDeclStr);
							if (!isCompatible(currentReturnType, methodSemInfo.returnType)) {
								System.err.println("Error: method '" + methodName + "' in '" + clsName + "' cannot override '" + methodName + "' in '" + parentClsName + "' with incompatible return type");
								err = true;
							}
						}
					}
				}
			}
			parentClsName = extTable.get(parentClsName);
		}
		if (vmtOffset > 0) {
			heapAlloc(vmtOffset);
			System.out.println(vmt);
		}
	}

	private MethodSemInfo postProcessMethodCall(final int ln, final String clsName, final String methodName, final LinkedList<SemInfo> paramList) {
		LinkedList<MethodSemInfo> methodSemInfoList = null;
		MethodSemInfo result = null;	
		if (!methodSemInfoTable.containsKey(clsName) || !methodSemInfoTable.get(clsName).containsKey(methodName)) {
			System.err.println("Error: line " + ln + ": '" + methodName + "' is undefined");
			err = true;
			return null;
		}
		methodSemInfoList = methodSemInfoTable.get(clsName).get(methodName);
		for (final MethodSemInfo methodSemInfo : methodSemInfoList) {
			if (isSubSignature(paramList, methodSemInfo.paramList)) {
				if (result == null) {
					result = methodSemInfo;
				}else if (!isSubSignature(result.paramList, methodSemInfo.paramList)) {
					if (!isSubSignature(methodSemInfo.paramList, result.paramList)) {
						System.err.println("Error: line " + ln + ": reference to '" + methodName + "' is ambiguous (more than one match is possible)");
						err = true;
						return null;
					}else {
						result = methodSemInfo;
					}
				}
			}
		}
		if (result == null) {
			System.err.println("Error: line " + ln + ": no suitable method found for '" + methodName + "'");
			err = true;
		}
		return result;
	}

	private void processVarDecl(final boolean isClsVar, final int ln, final String typeName, final String varName) {
		final VarType currentVarType = getVarType(typeName);
		if (currentVarType == VarType.UNKNOWN) {
			System.err.println("Error: " + ln + ": unknown type '" + typeName + "'");
			err = true;
		}else {
			if (isClsVar) {   /* NOTE: per Java specification, hiding any field from super class with an identical name is allowed */
				if (classSymbolTable.get(varName) != null) {
					System.err.println("Error: " + ln + ": redeclaration of '" + varName + "'");
					err = true;
				}else {
					classSymbolTable.put(varName, new SemInfo(currentVarType, class_offset++, typeName));
				}
			}else {
				/* in Java, one can declare a variable within a method that shadows the name of a class variable */
				if (methodSymbolTable.get(varName) != null) {
					System.err.println("Error: " + ln + ": redeclaration of '" + varName + "'");
					err = true;
				}else {
					methodSymbolTable.put(varName, new SemInfo(currentVarType, method_offset++, typeName));
				}
			}
		}
	}

	private void processBooleanLiteral(final String text) {
		final Integer currentEvalOffset = methodOffsetTable.get(new Integer(currentEval));
		if (!err) {
				if (printComment) {
					System.out.println("# F_" + currentEval +  " <- " + text);
				}
				System.out.println("\tli\t\$t1,\t" + (text.equals("true") ? 1 : 0));
		}
	}

	private void processBooleanVar(final int ln, final String varName) {
		boolean isClsVar = false;
		int abs_field_offset = -1;
		final Integer currentEvalOffset = methodOffsetTable.get(new Integer(currentEval));
		final SemInfo sinfo = methodSymbolTable.get(varName), field_sinfo[]; 
		if (sinfo == null) {
			field_sinfo = new SemInfo[1];
			abs_field_offset = getField(currentClassName, varName, field_sinfo); 
			if (field_sinfo[0] == null) {
				System.err.println("Error: " + ln + ": '" + varName + "' undeclared");
				err = true;
			}else {
				isClsVar = true;
			}
		}
		if (isClsVar) {
				if (!err) {
					if (printComment) {
						System.out.println("# F_" + currentEval + " <- " + varName);
					}
					System.out.println("\tlw\t\$t8,\t0(\$sp)");
					System.out.println("\tlw\t\$t1,\t" + (abs_field_offset << 2) + "(\$t8)");
				}
		}else {
				if (!err) {
					if (printComment) {
						System.out.println("# F_" + currentEval + " <- " + varName);
					}
					System.out.println("\tlw\t\$t1,\t" + (sinfo.offset << 2) + "(\$sp)");
				}
		}
	}

	private void processIntVar(final int ln, final String varName) {
		boolean isClsVar = false;
		int abs_field_offset = -1;
		final Integer currentEvalOffset = methodOffsetTable.get(new Integer(currentEval));
		final SemInfo sinfo = methodSymbolTable.get(varName), field_sinfo[]; 
		if (sinfo == null) {
			field_sinfo = new SemInfo[1];
			abs_field_offset = getField(currentClassName, varName, field_sinfo); 
			if (field_sinfo[0] == null) {
				System.err.println("Error: " + ln + ": '" + varName + "' undeclared");
				err = true;
			}else {
				isClsVar = true;
			}
		}
		FactorOp f_op = FactorOpStack.peek();
		FactorOpStack.pop();
		if (isClsVar) {
			if (f_op == FactorOp.NONE) {
				if (!err) {
					if (printComment) {
						System.out.println("# F_" + currentEval + " <- " + varName);
					}
					System.out.println("\tlw\t\$t8,\t0(\$sp)");
					System.out.println("\tlw\t\$t1,\t" + (abs_field_offset << 2) + "(\$t8)");
				}
			}else {
				if (!err) {
					System.out.println("\tlw\t\$t8,\t0(\$sp)");
					System.out.println("\tlw\t\$t2,\t" + (abs_field_offset << 2) + "(\$t8)");
					System.out.println("\t" + (f_op == FactorOp.MULT ? "mult" : "div") + "\t\$t1,\t\$t2");
					System.out.println("\tmflo\t\$t1");
				}
			}
		}else {
			if (f_op == FactorOp.NONE) {
				if (!err) {
					if (printComment) {
						System.out.println("# F_" + currentEval + " <- " + varName);
					}
					System.out.println("\tlw\t\$t1,\t" + (sinfo.offset << 2) + "(\$sp)");
				}
			}else {
				if (!err) {
					System.out.println("\tlw\t\$t2,\t" + (sinfo.offset << 2) + "(\$sp)");
					System.out.println("\t" + (f_op == FactorOp.MULT ? "mult" : "div") + "\t\$t1,\t\$t2");
					System.out.println("\tmflo\t\$t1");
				}
			}
		}
	}

	private void processStringVar(final String varName) {
		int abs_field_offset = -1;
		SemInfo sinfo = methodSymbolTable.get(varName), field_sinfo[]; 
		if (sinfo == null) {
			field_sinfo = new SemInfo[1];
			abs_field_offset = getField(currentClassName, varName, field_sinfo); 
			if (!err) {
				System.out.println("\tlw\t\$t8,\t0(\$sp)"); 
				System.out.println("\tlw\t\$t1,\t" + (abs_field_offset << 2) + "(\$t8)");
			}
		}else {
			if (!err) {
				System.out.println("\tlw\t\$t1,\t" + (sinfo.offset << 2) + "(\$sp)");
			}
		}
	}

	private void processObjectVar(final String varName, final boolean asFactor) {
		int abs_field_offset = -1;
		final SemInfo sinfo = methodSymbolTable.get(varName), field_sinfo[]; 
		if (sinfo == null) {
			field_sinfo = new SemInfo[1];
			abs_field_offset = getField(currentClassName, varName, field_sinfo); 
			if (!err) {
				System.out.println("\tlw\t\$t8,\t0(\$sp)"); 
				if (asFactor) {
					System.out.println("\tlw\t\$t1,\t" + (abs_field_offset << 2) + "(\$t8)");
				}else {
					System.out.println("\tlw\t\$t0,\t" + (abs_field_offset << 2) + "(\$t8)");
				}
			}
		}else {
			if (!err) {
				if (asFactor) {
					System.out.println("\tlw\t\$t1,\t" + (sinfo.offset << 2) + "(\$sp)");
				}else {
					System.out.println("\tlw\t\$t0,\t" + (sinfo.offset << 2) + "(\$sp)");
				}
			}
		}
	}

	private void processCondTerm(final int currentExprSCE) {
		if (declProcessed) {
			TermOp t_op = CondTermOpStack.peek();
			CondTermOpStack.pop();
			if (!err) {
				if (t_op == TermOp.NONE) {
					System.out.println("\tmove\t\$t4,\t\$t5");
				}else {
					System.out.println("\tor\t\$t4,\t\$t4,\t\$t5");
				}
				shortCircuitExpr(currentExprSCE);
			}
		}
	}

	private void shortCircuitTerm(final int currentTermSCE) {
		if (!err) {
			if (exprType == VarType.BOOLEAN) { 
				if (printComment) {
					System.out.println("# short-circuit evaluation");
				}
				System.out.println("\tbeq\t\$t5,\t\$zero,\t.L" + currentTermSCE);
			}
		}
	}

	private void shortCircuitExpr(int currentExprSCE) {
		if (!err) {
			if (exprType == VarType.BOOLEAN) { 
				if (printComment) {
					System.out.println("# short-circuit evaluation");
				}
				System.out.println("\tbne\t\$t4,\t\$zero,\t.L" + currentExprSCE);
			}
		}
	}

	private void processCondFactor() {
		FactorOp f_op = FactorOpStack.peek();
		FactorOpStack.pop();
		if (!err) {
			if (f_op == FactorOp.NONE) {
				System.out.println("\tmove\t\$t1,\t\$t0");
			}else {
				System.out.println("\tand\t\$t1,\t\$t1,\t\$t0");
			}
		}
	}

	private void negate() {
		if (!err) {
			if (printComment) {
				System.out.println("# F_" + currentEval + " <- !F_" + currentEval);
			}
			System.out.println("\txori\t\$t1,\t\$t1,\t1");
		}
	}

	private void processTerm(int ln) {
		final Integer currentEvalOffset = methodOffsetTable.get(new Integer(currentEval));
		final TermOp t_op = TermOpStack.peek();
		TermOpStack.pop();
		if (t_op == TermOp.NONE) {
			if (!err) {
				if (printComment) {
					System.out.println("# T_" + currentEval +  " <- F_" + currentEval);
				}
				System.out.println("\tmove\t\$t0,\t\$t1");
			}
		}else {
			if (!err) {
				if (printComment) {
					System.out.println("# T_" + currentEval +  " <- T_" + currentEval + termOpToString(t_op) + "F_" + currentEval);
				}
				if (exprType == VarType.INT) {
					System.out.println("\t" + (t_op == TermOp.ADD ? "add" : "sub") + "\t\$t0,\t\$t0,\t\$t1");
				}else if (exprType == VarType.STRING) {
					if (t_op != TermOp.ADD) {
						System.err.println("Error: " + ln + ": type mismatch, expected value of type int");
						err = true;
					}
					if (!err) {
						if (printComment) {
							System.out.println("# call stringConcat");
						}
						System.out.println("\tsw\t\$ra,\t" + (nextEvalOffset << 2) + "(\$sp)");
						System.out.println("\tmove\t\$a0,\t\$t0");
						System.out.println("\tmove\t\$a1,\t\$t1");
						System.out.println("\tsw\t\$fp,\t" + fpSave);
						System.out.println("\tsw\t\$sp,\t" + spSave);
						System.out.println("\tjal\t.stringConcat");
						System.out.println("\tlw\t\$fp,\t" + fpSave);
						System.out.println("\tlw\t\$sp,\t" + spSave);
						System.out.println("\tlw\t\$ra,\t" + (nextEvalOffset << 2) + "(\$sp)");
						System.out.println("\tmove\t\$t0,\t\$v0");
					}
				}else {
					System.err.println("Error: " + ln + ": type mismatch, expected value of type int or STRING");
					err = true;
				}
			}
		}
	}

	private int saveLHS() {
		final int lhsOffset = nextEvalOffset++;
		if (nextEvalOffset > method_offset) {
			method_offset = nextEvalOffset;
		}
		if (!err) {
			if (printComment) {
				System.out.println("# save LHS");
			}
			System.out.println("\tsw\t\$t0,\t" + (lhsOffset << 2) + "(\$sp)");
		}
		return lhsOffset;
	}

	private void newEval(int size) {
		final int __nextEvalOffset = nextEvalOffset + size;
		if (__nextEvalOffset >= method_offset) {
			method_offset = __nextEvalOffset;
		}
		methodOffsetTable.put(new Integer(++currentEval), new Integer(nextEvalOffset)); 
		nextEvalOffset = __nextEvalOffset;
	}

	private Ops beginEval(final boolean cond) {
		final FactorOp f_op = cond ? CondFactorOpStack.peek() : FactorOpStack.peek();
		final TermOp t_op = cond ? CondTermOpStack.peek() : TermOpStack.peek();
		if (f_op != FactorOp.NONE) {
			if (!err) {
				System.out.println("\tsw\t\$t1,\t" + (nextEvalOffset << 2) + "(\$sp)");
			}
			if (t_op != TermOp.NONE) {
				if (!err) {
					System.out.println("\tsw\t\$t0,\t" + ((nextEvalOffset + 1) << 2) + "(\$sp)");
				}
				newEval(2);
			}else {
				newEval(1);
			}
		}else if (t_op != TermOp.NONE) {
			if (!err) {
				System.out.println("\tsw\t\$t0,\t" + (nextEvalOffset << 2) + "(\$sp)");
			}
			newEval(1);
		}
		/* NOTE: operations can be integer equality / inequality comparisons inside a boolean eval */
		return new Ops(f_op, t_op);
	}

	private void endBooleanEval(final Ops ops) {
		FactorOpStack.pop();
		if (ops.factorOp != FactorOp.NONE) {
			Integer currentEvalOffset = methodOffsetTable.get(currentEval);
			--currentEval;
			if (!err) {
				if (printComment) {
					System.out.println("# F_" + currentEval + " <- F_" + currentEval + " && T_" + (currentEval + 1)); 
				}
				System.out.println("\tlw\t\$t1,\t" + (currentEvalOffset.intValue() << 2) + "(\$sp)");
				System.out.println("\tand\t\$t1,\t\$t1,\t\$t0");
			}
			if (ops.termOp != TermOp.NONE) {
				if (!err) {
					System.out.println("\tlw\t\$t0,\t" + ((currentEvalOffset.intValue() + 1) << 2) + "(\$sp)");
				}
				nextEvalOffset -= 2;
			}else {
				--nextEvalOffset;
			}
		}else {
			if (ops.termOp != TermOp.NONE) {
				Integer currentEvalOffset = methodOffsetTable.get(currentEval);
				--currentEval;
				if (!err) {
					if (printComment) {
						System.out.println("# F_" + currentEval + " <- T_" + (currentEval + 1)); 
					}
					System.out.println("\tmove\t\$t1,\t\$t0");
					System.out.println("\tlw\t\$t0,\t" + (currentEvalOffset.intValue() << 2) + "(\$sp)");
				}
				--nextEvalOffset;
			}else {
				if (!err) {
					if (printComment) {
						System.out.println("# F_" + currentEval + " <- T_" + currentEval); 
					}
					System.out.println("\tmove\t\$t1,\t\$t0");
				}
			}
		}
	}

	private void endIntEval(final Ops ops) {
		FactorOpStack.pop();
		if (ops.factorOp != FactorOp.NONE) {
			Integer currentEvalOffset = methodOffsetTable.get(currentEval);
			--currentEval;
			if (!err) {
				if (printComment) {
					System.out.println("# F_" + currentEval + " <- F_" + currentEval + factorOpToString(ops.factorOp) + "T_" + (currentEval + 1)); 
				}
				System.out.println("\tlw\t\$t1,\t" + (currentEvalOffset.intValue() << 2) + "(\$sp)");
				System.out.println("\t" + (ops.factorOp == FactorOp.MULT ? "mult" : "div") + "\t\$t1,\t\$t0");
				System.out.println("\tmflo\t\$t1");
			}
			if (ops.termOp != TermOp.NONE) {
				if (!err) {
					System.out.println("\tlw\t\$t0,\t" + ((currentEvalOffset.intValue() + 1) << 2) + "(\$sp)");
				}
				nextEvalOffset -= 2;
			}else {
				--nextEvalOffset;
			}
		}else {
			if (ops.termOp != TermOp.NONE) {
				Integer currentEvalOffset = methodOffsetTable.get(currentEval);
				--currentEval;
				if (!err) {
					if (printComment) {
						System.out.println("# F_" + currentEval + " <- T_" + (currentEval + 1)); 
					}
					System.out.println("\tmove\t\$t1,\t\$t0");
					System.out.println("\tlw\t\$t0,\t" + (currentEvalOffset.intValue() << 2) + "(\$sp)");
				}
				--nextEvalOffset;
			}else {
				if (!err) {
					if (printComment) {
						System.out.println("# F_" + currentEval + " <- T_" + currentEval); 
					}
					System.out.println("\tmove\t\$t1,\t\$t0");
				}
			}
		}
	}

	private void endStringEval(final Ops ops) {
		if (ops.termOp != TermOp.NONE) {
			Integer currentEvalOffset = methodOffsetTable.get(currentEval);
			--currentEval;
			if (!err) {
				System.out.println("\tmove\t\$t1,\t\$t0");
				System.out.println("\tlw\t\$t0,\t" + (currentEvalOffset.intValue() << 2) + "(\$sp)");
			}
			--nextEvalOffset;
		}else {
			if (!err) {
				System.out.println("\tmove\t\$t1,\t\$t0");
			}
		}
	}

	private void processRet() {
		if (exprType != VarType.INT) {
			if (!err) {
				System.out.println("\tmove\t\$t1,\t\$v0");
			}
		}else {
			FactorOp f_op = FactorOpStack.peek();
			FactorOpStack.pop();
			if (f_op == FactorOp.NONE) {
				if (!err) {
					System.out.println("\tmove\t\$t1,\t\$v0");
				}
			}else {
				if (!err) {
					System.out.println("\t" + (f_op == FactorOp.MULT ? "mult" : "div") + "\t\$t1,\t\$v0");
					System.out.println("\tmflo\t\$t1");
				}
			}
		}	
	}

	private void heapAlloc(int size) {
		if (!err) {
			if (printComment) {
				System.out.println("#using the syscall sbrk which allocates a block of heap space");
			}
			System.out.println("\tsw\t\$fp,\t" + fpSave);
			System.out.println("\tsw\t\$sp,\t" + spSave);
			System.out.println("\tli\t\$v0,\t9");
			System.out.println("\tli\t\$a0,\t" + (size << 2));
			System.out.println("\tsyscall");
			System.out.println("\tmove\t\$t0,\t\$v0");
			System.out.println("\tlw\t\$fp,\t" + fpSave);
			System.out.println("\tlw\t\$sp,\t" + spSave);
		}
	}

	private int saveTemp() {
		int reg_save_offset = nextEvalOffset;
		nextEvalOffset += 1 + numTempSave;
		if (nextEvalOffset > method_offset) {
			method_offset = nextEvalOffset;
		}
		if (!err) {
			for (int i = 0; i < numTempSave; ++i) {
				System.out.println("\tsw\t\$t" + i + ",\t" + ((reg_save_offset + i) << 2) + "(\$sp)");
			}
			System.out.println("\tsw\t\$ra,\t" + ((reg_save_offset + numTempSave) << 2) + "(\$sp)");
		}
		return reg_save_offset;
	}

	private int __saveTemp() {
		int reg_save_offset = nextEvalOffset;
		nextEvalOffset += numTempSave;
		if (nextEvalOffset > method_offset) {
			method_offset = nextEvalOffset;
		}
		if (!err) {
			for (int i = 0; i < numTempSave; ++i) {
				System.out.println("\tsw\t\$t" + i + ",\t" + ((reg_save_offset + i) << 2) + "(\$sp)");
			}
		}
		return reg_save_offset;
	}

	private void restoreTemp(int reg_save_offset) {
		if (!err) {
			for (int i = 0; i < numTempSave; ++i) {
				System.out.println("\tlw\t\$t" + i + ",\t" + ((reg_save_offset + i) << 2) + "(\$sp)");
			}
			System.out.println("\tlw\t\$ra,\t" + ((reg_save_offset + numTempSave) << 2) + "(\$sp)");
		}
		nextEvalOffset = reg_save_offset;
	}

	private void __restoreTemp(int reg_save_offset) {
		if (!err) {
			for (int i = 0; i < numTempSave; ++i) {
				System.out.println("\tlw\t\$t" + i + ",\t" + ((reg_save_offset + i) << 2) + "(\$sp)");
			}
		}
		nextEvalOffset = reg_save_offset;
	}

	private void subroutineReturn() {
		if (!err) {
			if (printComment) {
				System.out.println("# de-allocate stack space");
			}
			System.out.println("\tlw\t\$fp,\t" + (fp_save_offset << 2) + "(\$sp)");
			System.out.println("\tlw\t\$t0,\t" + (SS_prefix + currentClassName + '.' + currentMethodParamListStr) + "\n\tadd\t\$sp,\t\$sp,\t\$t0");
			if (printComment) {
				System.out.println("# return");
			}
			System.out.println("\tjr  \$ra\n");
		}
	}

	private void printBoolean() {
		if (!err) {
			int reg_save_offset;
			System.out.println("\tsw\t\$fp,\t" + fpSave);
			System.out.println("\tsw\t\$sp,\t" + spSave);
			reg_save_offset = saveTemp();
			System.out.println("\tjal\t.print_boolean");
			restoreTemp(reg_save_offset);
			System.out.println("\tlw\t\$fp,\t" + fpSave);
			System.out.println("\tlw\t\$sp,\t" + spSave);
		}
	}

	private void printInt() {
		if (!err) {
			if (printComment) {
				System.out.println("# call print_int");
			}
			System.out.println("\tsw\t\$fp,\t" + fpSave);
			System.out.println("\tsw\t\$sp,\t" + spSave);
			System.out.println("\tli\t\$v0,\t1");
			System.out.println("\tmove\t\$a0,\t\$t0");
			System.out.println("\tsyscall");
			System.out.println("\tlw\t\$fp,\t" + fpSave);
			System.out.println("\tlw\t\$sp,\t" + spSave);
		}
	}

	private void printString() { 
		if (!err) {
			if (printComment) {
				System.out.println("# call print_string");
			}
			System.out.println("\tsw\t\$fp,\t" + fpSave);
			System.out.println("\tsw\t\$sp,\t" + spSave);
			System.out.println("\tli\t\$v0,\t4");
			System.out.println("\tmove\t\$a0,\t\$t0");
			System.out.println("\tsyscall");
			System.out.println("\tlw\t\$fp,\t" + fpSave);
			System.out.println("\tlw\t\$sp,\t" + spSave);
		}
	}	

	private String termOpToString(final TermOp op) {
		return op == TermOp.OR ? " || " : op == TermOp.ADD ? " + " : op == TermOp.SUB ? " - " : "   ";
	}

	private String factorOpToString(final FactorOp op) {
		return op == FactorOp.AND ? " && " : op == FactorOp.MULT ? " * " : op == FactorOp.DIV ? " / " : "   ";
	}

	public void setProcessDecl(boolean processDecl) {
		this.processDecl = processDecl;
	}

	public void setPostProcessDecl(boolean postProcessDecl) {
		this.postProcessDecl = postProcessDecl;
	}

	public static void main(String[] args) throws Exception {
		try {
			final MiniJavaV3Lexer lex = new MiniJavaV3Lexer(new ANTLRFileStream(args[0]));
			final CommonTokenStream tokens = new CommonTokenStream(lex);
			final MiniJavaV3Parser parser = new MiniJavaV3Parser(tokens);
			parser.setProcessDecl(true);
			parser.setPostProcessDecl(false);
			parser.goal();
		} catch (RecognitionException e)  {
			e.printStackTrace();
			err = true;
		}
		if (!err) {
			try {
				final MiniJavaV3Lexer lex = new MiniJavaV3Lexer(new ANTLRFileStream(args[0]));
				final CommonTokenStream tokens = new CommonTokenStream(lex);
				final MiniJavaV3Parser parser = new MiniJavaV3Parser(tokens);
				parser.setProcessDecl(false);
				parser.setPostProcessDecl(true);
				parser.goal();
			} catch (RecognitionException e)  {
				e.printStackTrace();
				err = true;
			}
		}
		if (!err) {
			try{
				final MiniJavaV3Lexer lex = new MiniJavaV3Lexer(new ANTLRFileStream(args[0]));
				final CommonTokenStream tokens = new CommonTokenStream(lex);
				final MiniJavaV3Parser parser = new MiniJavaV3Parser(tokens);
				parser.setProcessDecl(false);
				parser.setPostProcessDecl(false);
				parser.goal();
			} catch (RecognitionException e)  {
				e.printStackTrace();
				err = true;
			}
		}
	}
}

/*------------------------------------------------------------------
 * PARSER RULES
 *------------------------------------------------------------------*/
goal :
			{
				declProcessed = !processDecl && !postProcessDecl;
				/*
				if (declProcessed) {
					if (methodCallIter.hasNext()) {
						nextMethodCall = methodCallIter.next();
					}
				}else
				*/
				if (postProcessDecl) {
					System.out.println("\t.text\n.globl main\nmain:");
					for (final String clsName : classTable.keySet()) {
						generateVMT(clsName);
					}
				}
			}
		mainClass
		classDeclaration *
			{
				if (declProcessed) {
					if (!err) {
						System.out.println(".print_boolean:\n\tbgtz\t\$t0,\t.print_boolean_true\n.print_boolean_false:\n\tla\t\$a0,\t.FALSE\n\tj\t.print_boolean_value\n.print_boolean_true:\n\tla\t\$a0,\t.TRUE\n\t# j\t.print_boolean_value\n.print_boolean_value:\n\tli\t\$v0,\t4\n\tsyscall\n\tjr\t\$ra\n" + StrLibText + "\n\n\t.data\n");
						System.out.println(".TRUE: .asciiz  \"true\"\n.FALSE: .asciiz  \"false\"\n" + data + StrLibData);
					}
				}else if (postProcessDecl) {
					for (final Map.Entry<String, HashMap<String, SemInfo>> cls : classTable.entrySet()) {
						final String currentClassName = cls.getKey();
						objSizeTable.put(currentClassName, new Integer(getObjSize(currentClassName)));
					}
				}
			}
	;

mainClass :
			/*{
				if (declProcessed) {
					if (!err) {
						System.out.println("\t.text\n.globl main\nmain:");
					}
				}
			}*/
	'class' Identifier '{' 
		'public' 'static' 'void' 'main' '(' 'String' '[' ']' Identifier ')' '{' 
			'new' cls=Identifier '(' ')' '.' method=Identifier '(' ')' ';'
			{
				if (declProcessed) {	
					if (!err) {
						System.out.println("\tsub\t\$sp,\t\$sp,\t8");
						System.out.println("\tsw\t\$fp,\t0(\$sp)");
						heapAlloc(1 + classTable.get($cls.text).size());
						System.out.println("\tlw\t\$t9,\t." + $cls.text + VMT_suffix);
						System.out.println("\tsw\t\$t9,\t0(\$t0)");
						if (printComment) {
							System.out.println("#load implicit \"this\" parameter");
						}
						System.out.println("\tsw\t\$t0,\t4(\$sp)");
						System.out.println("\taddi\t\$fp,\t\$sp,\t4");
						if (printComment) {
							System.out.println("# call " + $cls.text + "." + $method.text);
						}
						System.out.println("\tlw\t\$t9,\t0(\$t0)");

						System.out.println("\tlw\t\$t9,\t" + (methodSemInfoTable.get($cls.text).get($method.text).get(0).vmtOffset << 2) + "(\$t9)");
						System.out.println("\tjalr\t\$t9");
					}
				}
			}
		'}' 
	'}'
			{
				if (declProcessed) {
					if (!err) {
						System.out.println("\tlw\t\$fp,\t0(\$sp)");
						System.out.println("\tsub\t\$sp,\t\$sp,\t8");
						if (printComment) {
							System.out.println("# exit program");
						}
						System.out.println("\tli\t\$v0,\t10\n\tsyscall\n");
					}
				}
			}
	;

classDeclaration  : 
	'class' id=Identifier
			{
				class_offset = 0;
				/*class_offset = 1;*/   /* reserving 1st byte for VMT addr */
				currentClassName = $id.text;
				if (processDecl) {
					if (classTable.containsKey(currentClassName)) {
						System.err.println("Error: " + $id.line + ": duplicate class: '" + $id.text + "'");
						err = true;
					}else {
						classSymbolTable = new HashMap<String, SemInfo>();
						classTable.put(currentClassName, classSymbolTable);
						currentClassMethodDecls = new HashMap<String, SemInfo>();
						currentClassMethodParamListMap = new HashMap<String, LinkedList<MethodSemInfo>>();
						methodDeclTable.put(currentClassName, currentClassMethodDecls);
						methodSemInfoTable.put(currentClassName, currentClassMethodParamListMap);
					}
				}else {
					classSymbolTable = classTable.get(currentClassName);
				}
			}
	('extends' parentCls=Identifier
			{
				if (processDecl) {
					final String parentClassName = $parentCls.text;
					if (!classTable.containsKey(parentClassName)) {
						System.err.println("Error: " + $parentCls.line + ": cannot find symbol '" + parentClassName + "'"); 
					}else {
						extTable.put(currentClassName, parentClassName);
					}
				}
			}
	) ?
	'{' 
		fieldDeclaration *
		methodDeclaration *
	'}'
	;

varDeclaration :
	t=type id=Identifier ';'
		 	{ 	
				if (!processDecl) {
					processVarDecl(false, $id.line, $t.text, $id.text);
				}
			}
	;

fieldDeclaration : t=type id=Identifier ';'
			{
				if (processDecl) {
					processVarDecl(true, $id.line, $t.text, $id.text);
				}
			}
	;


methodDeclaration :
			{
				String methodDef, objType = null;
				VarType returnType;
				if (!processDecl) {
					method_offset = 1;  /* total amount of stack space used -- reserving one byte for storing the implicit "this" parameter */
					/* note: the value of the nextEvalOffset is reset by the varDeclaration rule */
					methodOffsetTable.clear();
					methodSymbolTable.clear();
				}
			}
	'public'
	(
		 'void'
		 	{
				returnType = VarType.VOID;
			}
		|
		 t=type
		 	{
				returnType = getVarType($t.text);
				if (returnType == VarType.OBJECT) {
					objType = $t.text;
				}
			}
	)
	method=Identifier
			{
				currentMethodParamListStr = $method.text;
				if (processDecl) {
					LinkedList<MethodSemInfo> sgnList;
					currentMethodParamList = new LinkedList<SemInfo>();
					if (!currentClassMethodParamListMap.containsKey($method.text)) {
						sgnList = new LinkedList<MethodSemInfo>();
						currentClassMethodParamListMap.put($method.text, sgnList);
					}else {
						sgnList = currentClassMethodParamListMap.get($method.text);
					}
					sgnList.add(new MethodSemInfo(new SemInfo(returnType, 0, objType), currentMethodParamList));
				}
				methodDef = $method.text + "(";
			}
	'('
			{
				int paramOffset = -1;   /* for loading implicit "this" parameter */
				loadParam = "";
				if (printComment) {
					loadParam += "# loading implicit \"this\" parameter\n";
				}
				loadParam += "\tlw\t\$t8,\t0(\$fp)\n\tsw\t\$t8,\t0(\$sp)\n";
			}
	(
		t=type id=Identifier
			{
				VarType currentParamType = getVarType($t.text);
				currentMethodParamListStr += "." + $t.text;
				methodDef += $t.text;
				if (!processDecl) {
					if (currentParamType == VarType.UNKNOWN) {
						System.err.println("Error: " + $id.line + ": unknown type '" + $t.text + "'");
						err = true;
					}else {
						/* in Java, one can have a parameter in a method that shadows the name of a class variable */
						if (methodSymbolTable.get($id.text) != null) {
							System.err.println("Error: " + $id.line + ": redeclaration of '" + $id.text + "'");
							err = true;
						}else {
							final SemInfo param_sinfo = new SemInfo(currentParamType, method_offset++, ($t.text.equals("boolean") || $t.text.equals("int") || $t.text.equals("String") ? null : $t.text));
							methodSymbolTable.put($id.text, param_sinfo);
							if (!postProcessDecl) {
								if (!err) {
									if (printComment) {
										loadParam += "# loading 1st parameter\n";
									}
									loadParam += "\tlw\t\$t8,\t" + (paramOffset << 2) + "(\$fp)\n\tsw\t\$t8,\t" + ((method_offset - 1) << 2) + "(\$sp)\n";
									--paramOffset;
								}
							}
						}
					}
				}else {
					final SemInfo param_sinfo = new SemInfo(currentParamType, method_offset++, ($t.text.equals("boolean") || $t.text.equals("int") || $t.text.equals("String") ? null : $t.text));
					currentMethodParamList.add(param_sinfo);
				}
			}
		( ',' t=type id=Identifier
			{
				currentParamType = getVarType($t.text);
				currentMethodParamListStr += "." + $t.text;
				methodDef += "," + $t.text;
				if (!processDecl) { 
					if (currentParamType == VarType.UNKNOWN) {
						System.err.println("Error: " + $id.line + ": unknown type '" + $t.text + "'");
						err = true;
					}else {
						/* in Java, one can have a parameter in a method that shadows the name of a class variable */
						if (methodSymbolTable.get($id.text) != null) {
							System.err.println("Error: " + $id.line + ": redeclaration of '" + $id.text + "'");
							err = true;
						}else {
							final SemInfo param_sinfo = new SemInfo(currentParamType, method_offset++, ($t.text.equals("boolean") || $t.text.equals("int") || $t.text.equals("String") ? null : $t.text));
							methodSymbolTable.put($id.text, param_sinfo);
							if (!postProcessDecl) {
								if (!err) {
									if (printComment) {
										loadParam += "# loading subsequent parameters\n";
									}
									loadParam += "\tlw\t\$t8,\t" + (paramOffset << 2) + "(\$fp)\n\tsw\t\$t8,\t" + ((method_offset - 1) << 2) + "(\$sp)\n";
									--paramOffset;
								}
							}
						}
					}
				}else {
					final SemInfo param_sinfo = new SemInfo(currentParamType, method_offset++, ($t.text.equals("boolean") || $t.text.equals("int") || $t.text.equals("String") ? null : $t.text));
					currentMethodParamList.add(param_sinfo);
				}
			}
		)* )?  ')' '{'
			{
				methodDef += ")";
				if (processDecl) {  /* TODO: find what is in Java lang spec */
					if (currentClassMethodDecls.containsKey(currentClassName + '.' + currentMethodParamList)) {
						System.err.println("Error: " + $method.line + ": " + methodDef + " is already defined");
						err = true;
					}
					currentClassMethodDecls.put(currentMethodParamListStr, new SemInfo(returnType, 0, returnType == VarType.OBJECT ? objType : null));
				}else if (declProcessed) {
					if (!err) {
						System.out.println(currentClassName + '.' + currentMethodParamListStr + ":");
						if (printComment) {
							System.out.println("# allocate stack space");
						}
						System.out.println("\tlw\t\$t0,\t" + (SS_prefix + currentClassName + '.' + currentMethodParamListStr) + "\n\tsub\t\$sp,\t\$sp,\t\$t0");
						/* reserving 1 byte of stack space for saving the frame pointer */
					}
					fp_save_offset = method_offset++;
					if (!err) {
						System.out.println("\tsw\t\$fp,\t" + (fp_save_offset << 2) + "(\$sp)");
						System.out.println(loadParam);
						loadParam = "";
					}
				}
			}
		( varDeclaration )* 
			{
				if (declProcessed) {
					/* reserving 2 bytes of stack space for current term and factor evaluations */
					methodOffsetTable.put(new Integer(0), new Integer(method_offset));
					method_offset += 2;
					nextEvalOffset = method_offset;
				}
			}
		( statement )* 
	'}'
			{
				if (declProcessed) {
					if (!err) {
						subroutineReturn();

						if (printComment) {
							data += "# total amount of stack space required for method '" + currentClassName + '.' + currentMethodParamListStr + "'\n";
						}
						data += SS_prefix + currentClassName + '.' + currentMethodParamListStr + ": .word  " + (method_offset << 2) + "\n";   /* +2 for possible evals in return statement */
					}
				}
			}
	;

type : 
	'boolean'
	| 'int'
	| 'String'
	| Identifier
	;

statement :
			{
				if (declProcessed) {
					currentEval = 0;
				}
			}
	'System.out.print' '(' expression ')' ';'
			{
				if (declProcessed) {
					if (!err) {
						if (printComment) {
							System.out.println("# print " + exprType);
						}
					}
					if (exprType == VarType.BOOLEAN) {
						printBoolean();
					}else if (exprType == VarType.INT) {
						printInt();
					}else if (exprType == VarType.STRING) {
						printString();
					}
				}
			}
	|
	id=Identifier '=' expression ';'
			{
				if (declProcessed) {
					boolean isClsVar = false;
					int abs_field_offset = -1;
					SemInfo sinfo = methodSymbolTable.get($id.text);	
					if (sinfo == null) {
						/* if current symbol is not found in the method symbol table, try locating it in the class symbol table */
						final SemInfo field_sinfo[] = new SemInfo[1];
						abs_field_offset = getField(currentClassName, $id.text, field_sinfo); 
						sinfo = field_sinfo[0];
						if (sinfo == null) {
							System.err.println("Error: " + $id.line + ": '" + $id.text + "' undeclared");
							err = true;
						}else {
							isClsVar = true;
						}
					}
					if (sinfo != null) {
						if (sinfo.type != VarType.OBJECT) {
							if (sinfo.type != exprType) {
								System.err.println("Error: " + $id.line + ": type mismatch, expected value of type '" + getVarTypeStr(sinfo.type) + "'");
								err = true;
							}
						}else{
							if (exprType != VarType.OBJECT || !isA(currentObjType, sinfo.clsName)) {
								System.err.println("Error: " + $id.line + ": type mismatch, expected value of type '" + sinfo.clsName + "'");
								err = true;
							}
						}
					}
					if (!err) {
						if (printComment) {
							System.out.println("# variable assignment");
						}
						if (isClsVar) {
							System.out.println("\tlw\t\$t8,\t0(\$sp)");
							System.out.println("\tsw\t\$t0,\t" + (abs_field_offset << 2) + "(\$t8)");
						}else {
							System.out.println("\tsw\t\$t0,\t" + (sinfo.offset << 2) + "(\$sp)");
						}
					}
				}
			}
	|
	dot_subexpr_field_l_value
			{
				int lhsAddrOffset = 0;
				VarType lhsType = VarType.UNKNOWN;
				if (declProcessed) {
					lhsAddrOffset = saveLHS();
					lhsType = exprType;
				}
			}
	'=' expression
			{
				if (declProcessed) {
					if (exprType != lhsType) {
						System.err.println("Error: " + getCurrentToken().getLine() + ": type mismatch, expected value of type '" + getVarTypeStr(lhsType) + "'");
						err = true;
					}
					if (!err) {
						System.out.println("\tlw\t\$t8,\t" + (lhsAddrOffset << 2) + "(\$sp)");
						System.out.println("\tsw\t\$t0,\t(\$t8)");
					}
				}
			}
	';'
	|
			{
				final int nextLabel = numLabel;
				numLabel += 2;
			}
	'if' '(' expression
	')' 
			{
				if (declProcessed) {
					if (!err) {
						System.out.println("\tbne\t\$t0,\t\$zero,\t.L" + nextLabel + "\n\tj\t.L" + (nextLabel + 1) + "\n.L" + nextLabel + ":");
					}
				}
			}
	statement
			{
				if (declProcessed) {
					if (!err) {
						System.out.println(".L" + (nextLabel + 1) + ":");
					}
				}
			}
	|
			{
				final int nextLabel = numLabel;
				numLabel += 3;
			}
	'if' '(' expression ')' 
			{
				if (declProcessed) {
					if (!err) {
						System.out.println("\tbne\t\$t0,\t\$zero,\t.L" + nextLabel + "\n\tj\t.L" + (nextLabel + 1) + "\n.L" + nextLabel + ":");
					}
				}
			}
	statement
			{
				if (declProcessed) {
					if (!err) {
						System.out.println("\tj\t.L" + (nextLabel + 2) + "\n.L" + (nextLabel + 1) + ":");
					}
				}
			}
	'else' statement
			{
				if (declProcessed) {
					if (!err) {
						System.out.println(".L" + (nextLabel + 2) + ":");
					}
				}
			}
	|
			{
				final int nextLabel = numLabel;
				numLabel += 3;
				if (declProcessed) {
					if (!err) {
						System.out.println(".L" + nextLabel + ":");
					}
				}
			}
	'while' '(' expression ')'
			{
				if (declProcessed) {
					if (!err) {
						System.out.println("\tbne\t\$t0,\t\$zero,\t.L" + (nextLabel + 1) + "\n\tj\t.L" + (nextLabel + 2) + "\n.L" + (nextLabel + 1) + ":");
					}
				}
			}
	statement
			{
				if (declProcessed) {
					if (!err) {
						System.out.println("\tj\t.L" + nextLabel + "\n\t.L" + (nextLabel + 2) + ":");
					}
				}
			}
	|
	this_methodcall ';'
	|
	dot_subexpr_methodcall ';'	
	|
	'return' ';'
		{
			if (declProcessed) {
				subroutineReturn();
			}
		}
	|
	'return' expression
	';'
			{
				if (declProcessed) {
					if (!err) {
						System.out.println("\tmove\t\$v0,\t\$t0");
						subroutineReturn();
					}
				}
			}
	|
	'{'  statement * '}'
	;


methodcall :
			{
				int numParam = 1, current_offset = -1, _current_offset = 0, reg_save_offset = 0/*, current_vmt_offset = 0*/;
				String currentMethodCallCls = "";
				LinkedList<SemInfo> currentMethodCallParamList = null;
				MethodCall currentMethodCall = null;
				if (!processDecl) {
					currentMethodCallParamList = new LinkedList<SemInfo>();
				}
				if (declProcessed) {
					currentMethodCall = methodCallIter.next();
					numParam = currentMethodCall.numParam;
					nextEvalOffset += numParam;
					if (nextEvalOffset > method_offset) {
						method_offset = nextEvalOffset;
					}
					current_offset = nextEvalOffset - 1;

					_current_offset = current_offset;
					if (!err) {
						if (printComment) {
							System.out.println("# storing implicit \"this\" parameter");
						}
						if (thisMethodCall) {
							System.out.println("\tlw\t\$t8,\t0(\$sp)");
							System.out.println("\tsw\t\$t8,\t" + (current_offset << 2) + "(\$sp)");
						}else {
							System.out.println("\tsw\t\$t0,\t" + (current_offset << 2) + "(\$sp)");
						}
					}
					--current_offset;
				}
			}
	method=Identifier '('
			{
				if (!processDecl) {
					currentMethodCallCls = thisMethodCall ? currentClassName : currentObjType;
				}
				if (declProcessed) {
					reg_save_offset = saveTemp();
				}
			}
	( expression
			{
				if (!processDecl) {
					currentMethodCallParamList.add(new SemInfo(exprType, 0, exprType == VarType.OBJECT ? currentObjType : null));	
					// debugging output with stdout redirected to /dev/null :
					// System.err.println("# param type == " + exprType + " param == " + $expression.text);
					if (!postProcessDecl) {
						if (!err) {
							if (printComment) {
								System.out.println("# storing 1st parameter");
							}
							System.out.println("\tsw\t\$t0,\t" + (current_offset << 2) + "(\$sp)");   // load 1st parameter
						}
						--current_offset;
					}else {
						++numParam;
					}
				}
			}
	 ( ',' expression 
	 		{
				if (!processDecl) {
					currentMethodCallParamList.add(new SemInfo(exprType, 0, exprType == VarType.OBJECT ? currentObjType : null));	
					// debugging output with stdout redirected to /dev/null:
					// System.err.println("# param type == " + exprType + " param == " + $expression.text);
					if (!postProcessDecl) {
						if (!err) {
							if (printComment) {
								System.out.println("# storing subsequent parameter(s)");
							}
							System.out.println("\tsw\t\$t0,\t" + (current_offset << 2) + "(\$sp)");   // save subsequent parameters
						}
						--current_offset;
					}else {
						++numParam;
					}
				}
			}
	 )* )?
	')'
			{
				MethodSemInfo result = null;
				if (!processDecl) {
					result = postProcessMethodCall(getCurrentToken().getLine(), currentMethodCallCls, $method.text, currentMethodCallParamList);
				}
				if (postProcessDecl) {
					exprType = err ? VarType.UNKNOWN : result.returnType.type;
					if (exprType == VarType.OBJECT) {
						methodCall.add(new MethodCall(result.vmtOffset, numParam, result.returnType.clsName));
						currentObjType = result.returnType.clsName;
					}else {
						methodCall.add(new MethodCall(result.vmtOffset, numParam, exprType));
					}
					// debugging output with stdout redirected to /dev/null:
					// System.err.println("# " + $methodcall.text + ": return type == " + exprType);
				}else if (declProcessed) {
					if (!err) {
						System.out.println("\taddi\t\$fp,\t\$sp,\t" + (_current_offset << 2)); 
						System.out.println("\tlw\t\$t9,\t0(\$fp)");
						System.out.println("\tlw\t\$t9,\t0(\$t9)");
						System.out.println("\tlw\t\$t9,\t" + (result.vmtOffset << 2) + "(\$t9)");
						System.out.println("\tjalr\t\$t9");
						System.out.println("\tlw\t\$fp,\t" + (fp_save_offset << 2) + "(\$sp)");
						restoreTemp(reg_save_offset);
					}
					exprType = currentMethodCall.returnType;
					if (exprType == VarType.OBJECT) {
						currentObjType = currentMethodCall.objType;
					}
					nextEvalOffset -= numParam;
					// debugging output with stdout redirected to /dev/null:
					// System.err.println("# " + $methodcall.text + ": return type == " + exprType);
				}
			}
	;

this_methodcall :
			{
				thisMethodCall = true;
			}
			methodcall
	;

expression :
			{
				if (declProcessed) {
					CondTermOpStack.push(TermOp.NONE);
				}
			}
	cond_expression
			{
				if (declProcessed) {
					if (!err) {
						System.out.println("\tmove\t\$t0,\t\$t4");
						System.out.println("\tmove\t\$t1,\t\$t5");
					}	
				}
			}
	|
			'new'  cls=Identifier '(' ')'
			{
				exprType = VarType.OBJECT;
				if (declProcessed) {
					if (!classTable.containsKey($cls.text)) {
						System.err.println("Error: " + $cls.line + ": unknown type '" + $cls.text + "'");
						err = true;
					}else {
						currentObjType = $cls.text;
						heapAlloc(1 + objSizeTable.get($cls.text).intValue());   /* reserving 1st byte for VMT address */
						if (!err) {
							System.out.println("\tlw\t\$t9,\t." + $cls.text + VMT_suffix);
							System.out.println("\tsw\t\$t9,\t0(\$t0)");
						}
					}
				}
			}
	;

rel_expression :
	(
			{
				if (declProcessed) {
					FactorOpStack.push(FactorOp.NONE);
				}
			}
		rel_term
		 	{
				if (declProcessed) {
					processTerm(getCurrentToken().getLine());
				}
			}
		(
		 op = ('+' | '-')
			{
				if (declProcessed) {
					TermOpStack.push($op.text.equals("+") ? TermOp.ADD : TermOp.SUB);
					FactorOpStack.push(FactorOp.NONE);
				}
			}
		rel_term
		 	{
				if (declProcessed) {
					processTerm(getCurrentToken().getLine());
				}
			}
		) *
	)
	(
		'>' 
			{
				int lhsOffset = 0;
				if (declProcessed) {
					if (exprType != VarType.INT) {
						System.err.println("Error: " + getCurrentToken().getLine() + ": type mismatch, expected value of type int");
						err = true;
					}
					lhsOffset = saveLHS();
					TermOpStack.push(TermOp.NONE);
				}
			}
		rel_expression
			{
				if (declProcessed) {
					if (exprType != VarType.INT) {
						System.err.println("Error: " + getCurrentToken().getLine() + ": type mismatch, expected value of type int");
						err = true;
					}
				}
				exprType = VarType.BOOLEAN;
				currentObjType = null;
				if (declProcessed) {
					if (!err) {
						if (printComment) {
						        System.out.println("# LHS");
						}
						System.out.println("\tlw\t\$t2,\t" + (lhsOffset << 2) + "(\$sp)");
						if (printComment) {
						        System.out.println("# RHS");
						}
						System.out.println("\tslt\t\$t0,\t\$t0,\t\$t2");
					}
					--nextEvalOffset;
				}
			}
		|
			{
				int lhsOffset = 0;
				if (declProcessed) {
					lhsOffset = saveLHS();
					TermOpStack.push(TermOp.NONE);
				}
			}
		'<' rel_expression
			{
				if (declProcessed) {
					if (exprType != VarType.INT) {
						System.err.println("Error: " + getCurrentToken().getLine() + ": type mismatch, expected value of type int");
						err = true;
					}
				}
				exprType = VarType.BOOLEAN;
				currentObjType = null;
				if (declProcessed) {
					if (!err) {
						if (printComment) {
						        System.out.println("# LHS");
						}
						System.out.println("\tlw\t\$t2,\t" + (lhsOffset << 2) + "(\$sp)");
						if (printComment) {
						        System.out.println("# RHS");
						}
						System.out.println("\tslt\t\$t0,\t\$t2,\t\$t0");
					}
					--nextEvalOffset;
				}
			}
		|
			{
				int lhsOffset = 0;
				if (declProcessed) {
					lhsOffset = saveLHS();
					TermOpStack.push(TermOp.NONE);
				}
			}
		'>=' rel_expression
			{
				if (declProcessed) {
					if (exprType != VarType.INT) {
						System.err.println("Error: " + getCurrentToken().getLine() + ": type mismatch, expected value of type int");
						err = true;
					}
				}
				exprType = VarType.BOOLEAN;
				currentObjType = null;
				if (declProcessed) {
					if (!err) {
						if (printComment) {
						        System.out.println("# LHS");
						}
						System.out.println("\tlw\t\$t2,\t" + (lhsOffset << 2) + "(\$sp)");
						if (printComment) {
						        System.out.println("# RHS");
						}
						System.out.println("\tslt\t\$t0,\t\$t2,\t\$t0");
						System.out.println("\txori\t\$t0,\t\$t0,\t1");
					}
					--nextEvalOffset;
				}
			}
		|
			{
				int lhsOffset = 0;
				if (declProcessed) {
					lhsOffset = saveLHS();
					TermOpStack.push(TermOp.NONE);
				}
			}
		'<=' rel_expression
			{
				if (declProcessed) {
					if (exprType != VarType.INT) {
						System.err.println("Error: " + getCurrentToken().getLine() + ": type mismatch, expected value of type int");
						err = true;
					}
				}
				exprType = VarType.BOOLEAN;
				currentObjType = null;
				if (declProcessed) {
					if (!err) {
						if (printComment) {
						        System.out.println("# LHS");
						}
						System.out.println("\tlw\t\$t2,\t" + (lhsOffset << 2) + "(\$sp)");
						if (printComment) {
						        System.out.println("# RHS");
						}
						System.out.println("\tslt\t\$t0,\t\$t0,\t\$t2");
						System.out.println("\txori\t\$t0,\t\$t0,\t1");
					}
					--nextEvalOffset;
				}
			}
	)?
	;

rel_expression_ :
	/* epsilon */
	|
	op = ('+' | '-')
			{
				if (declProcessed) {
					TermOpStack.push($op.text.equals("+") ? TermOp.ADD : TermOp.SUB);
				}
			}
	rel_expression
	;

rel_term :
	rel_factor rel_term_
	;

rel_term_ :
	/* epsilon */
	|
	op = ('*' | '/')
			{
				if (declProcessed) {
					FactorOpStack.push($op.text.equals("*") ? FactorOp.MULT : FactorOp.DIV);
				}
			}
	rel_term
	;

rel_factor :
	b=BooleanLiteral
			{
				exprType = VarType.BOOLEAN;
				currentObjType = null;
				if (declProcessed) {
					processBooleanLiteral($b.text);
				}
			}
	|
	n=Negation
	{
		exprType = VarType.BOOLEAN;
		currentObjType = null;
	}
	(
		b=BooleanLiteral
			{
				if (declProcessed) {
					processBooleanLiteral($b.text);
				}
			}
		|
		id=Identifier
			{
				if (declProcessed) {
					final VarType type = getIdType($id.text);
					if (type != VarType.BOOLEAN) {
						System.err.println("Error: " + $id.getLine() + ": type mismatch, expected boolean");
						err = true;
					}
					processBooleanVar($id.line, $id.text);
				}

			}
		|
		(
		 this_methodcall
		|
			{
				int reg_save_offset = 0;
				if (declProcessed) {
					reg_save_offset = __saveTemp();
				}
			}
		(
	 	  dot_subexpr_methodcall
		 |
		  dot_subexpr_field
		)
		 	{
				if (declProcessed) {
					__restoreTemp(reg_save_offset);
				}
			}
		)
			{
				if (declProcessed) {
					if (exprType != VarType.BOOLEAN) {
						System.err.println("Error: " + getCurrentToken().getLine() + ": type mismatch, expected boolean");
						err = true;
					}
					processRet();
				}
			}
		|
			{
				Ops ops = null;
				if (declProcessed) {
					ops = beginEval(false);
				}
			}
		'(' expression ')'
			{
				if (declProcessed) {
					if (exprType == VarType.BOOLEAN) {
						endBooleanEval(ops);
					}else {
						System.err.println("Error: " + getCurrentToken().getLine() + ": type mismatch, expected boolean");
						err = true;
					}
					if (!err) {
						System.out.println("\tmove\t\$t1,\t\$t0");
					}
				}
			}
	)
			{
				if (declProcessed) {
					if (!err) {
						if ($n.text.length() % 2 == 1) {
							negate();
						}
					}
				}
			}

	|
	v=IntegerLiteral
			{
				exprType = VarType.INT;
				currentObjType = null;
				if (declProcessed) {
					final Integer currentEvalOffset = methodOffsetTable.get(new Integer(currentEval));
					final FactorOp f_op = FactorOpStack.peek();
					FactorOpStack.pop();
					if (f_op == FactorOp.NONE) {
						if (!err) {
							if (printComment) {
								System.out.println("# F_" + currentEval +  " <- " + $v.text);
							}
							System.out.println("\tli\t\$t1,\t" + $v.text);
						}
					}else {
						if (!err) {
							if (printComment) {
								System.out.println("# F_" + currentEval + "  <- F_" + currentEval + (f_op == FactorOp.MULT ? " * " : " / ") + $v.text);
							}
							System.out.println("\tli\t\$t2,\t" + $v.text);
							System.out.println("\t" + (f_op == FactorOp.MULT ? "mult" : "div") + "\t\$t1,\t\$t2");
							System.out.println("\tmflo\t\$t1");
						}
					}
				}
			}
	|
	StringLiteral
			{
				exprType = VarType.STRING;
				if (declProcessed) {
					int currentStringLiteral;
					final Integer N = strTable.get($StringLiteral.text);
					if (N != null) {
						currentStringLiteral = N.intValue();
					}else {
						data += ".str" + numStringLiteral + ": .asciiz  " + $StringLiteral.text + "\n";
						strTable.put($StringLiteral.text, new Integer(numStringLiteral));
						currentStringLiteral = numStringLiteral++;
					}
					if (!err) {
						System.out.println("\tla\t\$t1,\t.str" + currentStringLiteral);
					}
				}
				currentObjType = null;
			}
	|
	o=ObjectLiteral
			{
				exprType = VarType.OBJECT;
				if (declProcessed) {
					if (!err) {
						if ($o.text.equals("this")) {  
							System.out.println("\tlw\t\$t1,\t0(\$sp)");
							currentObjType = currentClassName;

						}else {
							System.out.println("\tli\t\$t1,\t0");
							currentObjType = NULL_TYPE;
						}
					}
				}
			}
	|
	id=Identifier
			{
				final VarType varType = getIdType($id.text);
				exprType = varType;
				currentObjType = null;
				if (!processDecl) {
					if (varType == VarType.OBJECT)  {
						currentObjType = getObjectVarClsName($id.text);
					}
				}
				if (declProcessed) {
					if (varType == VarType.BOOLEAN) {
						processBooleanVar($id.line, $id.text);
					}else if (varType == VarType.INT) {
						processIntVar($id.line, $id.text);
					}else if (varType == VarType.STRING) {
						processStringVar($id.text);
					}else if (varType == VarType.OBJECT)  {
						processObjectVar($id.text, true);
					}
				}
			}
	|
			{
				Ops ops = null;
				if (declProcessed) {
					ops = beginEval(exprType == VarType.BOOLEAN);
				}
			}
	'(' expression ')'
			{
				if (declProcessed) {
					if (exprType == VarType.BOOLEAN) {
						endBooleanEval(ops);
					}else if (exprType == VarType.INT) {
						endIntEval(ops);
					}else if (exprType == VarType.STRING) {
						endStringEval(ops);
					}
				}
			}
	|
	(
	 this_methodcall
	|
			{
				int reg_save_offset = 0;
				if (declProcessed) {
					reg_save_offset = __saveTemp();
				}
			}
	(
	  dot_subexpr_methodcall
	 |
	  dot_subexpr_field
	)
			{
				if (declProcessed) {
					__restoreTemp(reg_save_offset);
				}
			}
	)
			{
				if (declProcessed) {
					processRet();

				}
			}
	;

cond_expression :
			{
				int currentExprSCE = 0;
				if (declProcessed) {
					currentExprSCE = numLabel++;
					CondFactorOpStack.push(FactorOp.NONE);
				}
			}
		cond_term
		 	{
				processCondTerm(currentExprSCE);
			}
		(
		'||'
			{
				if (declProcessed) {
					CondTermOpStack.push(TermOp.OR);
					CondFactorOpStack.push(FactorOp.NONE);
				}
			}
		cond_term
			{
				processCondTerm(currentExprSCE);
			}
		) *
			{
				if (declProcessed) {
					if (exprType == VarType.BOOLEAN) {
						if (!err) {
							if (printComment) {
								System.out.println("# short-circuit evaluation");
							}
							System.out.println(".L" + currentExprSCE + ":");
						}
					}
				}
			}
	;

cond_term :
			{
				int currentTermSCE = 0;
				if (declProcessed) {
					currentTermSCE = numLabel++;
				}
			}
	cond_factor
			{
				if (declProcessed) {
					shortCircuitTerm(currentTermSCE);
				}
			}
	(
	 '&&'
			{
				if (declProcessed) {
					CondFactorOpStack.push(FactorOp.AND);
				}
			}
	 cond_factor
	 		{
				if (declProcessed) {
					shortCircuitTerm(currentTermSCE);
				}
			}
	) *
		{
			if (declProcessed) {
				if (exprType == VarType.BOOLEAN) {
					if (!err) {
						if (printComment) {
							System.out.println("# short-circuit evaluation");
						}
						System.out.println(".L" + currentTermSCE + ":");
					}
				}
			}
		}
	;

cond_factor :
			{
				if (declProcessed) {
					TermOpStack.push(TermOp.NONE);
				}
			}
	rel_expression
			{
				if (declProcessed) {
					final FactorOp f_op = CondFactorOpStack.peek();
					CondFactorOpStack.pop();
					if (!err) {
						if (f_op == FactorOp.NONE) {
							System.out.println("\tmove\t\$t5,\t\$t0");
						}else {
							System.out.println("\tand\t\$t5,\t\$t5,\t\$t0");
						}
					}
				}
			}
	|
			{
				if (declProcessed) {
					TermOpStack.push(TermOp.NONE);
				}
			}
	rel_expression
	(
			{
				int lhsOffset = 0;
				String lhsObjType = null, rhsObjType = null;
				VarType lhsExprType = null, rhsExprType = null;
				if (declProcessed) {
					lhsObjType = currentObjType;
					lhsExprType = exprType;
					lhsOffset = saveLHS();
				}
			}
	'=='
			{
				if (declProcessed) {
					TermOpStack.push(TermOp.NONE);
				}
			}
	rel_expression
			{
				if (declProcessed) {
					rhsObjType = currentObjType;
					rhsExprType = exprType;
					if (lhsExprType != VarType.OBJECT) {
						if (lhsExprType != rhsExprType) {
							System.err.println("Error: line " + getCurrentToken().getLine() + ": incompatible types");
							err = true;
						}
					}else if (!isA(rhsObjType, lhsObjType) && !isA(lhsObjType, rhsObjType)) {
						System.err.println("Error: line " + getCurrentToken().getLine() + ": incompatible types");
						err = true;
					}
				}
				exprType = VarType.BOOLEAN;
				currentObjType = null;
				if (declProcessed) {
					if (!err) {
						System.out.println("\tlw\t\$t6,\t" + (lhsOffset << 2) + "(\$sp)");
						if (printComment) {
						        System.out.println("# RHS");
						}
						System.out.println("\tmove\t\$t7,\t\$t0");
						System.out.println("\txor\t\$t5,\t\$t6,\t\$t7\n");
						System.out.println("\tsltiu\t\$t5,\t\$t5,\t1");
						System.out.println("\tmove\t\$t0,\t\$t5");
					}
					--nextEvalOffset;
				}
			}
	)+
	;

dot_subexpr_ref :
	(
	o=ObjectLiteral
			{
				if (!processDecl) {
					currentObjType = currentClassName;
				}
				if (declProcessed) {
					if ($o.equals("null")) {
						System.err.println("Error: " + $id.line + ": <null> cannot be dereferenced");
						err = true;
					}
					if (!err) {  /* this */
						System.out.println("\tlw\t\$t0,\t0(\$sp)");
					}
				}
			}
	|
	 id=Identifier
	 		{
				if (!processDecl) {
					if (getIdType($id.text) != VarType.OBJECT) {
						System.err.println("Error: " + $id.line + ": non-object type cannot be dereferenced");
						err = true;
					}
					currentObjType = getObjectVarClsName($id.text);
				}
				if (declProcessed) {
					if (!err) {
						processObjectVar($id.text, false);
					}
				}
			}
	|
	(
	 '('
	 expression
	 ')'
	 |
	 this_methodcall
	 		{
				if (declProcessed) {
					if (!err) {
						System.out.println("\tmove\t\$t0,\t\$v0");
					}
				}
			}
	)
	 		{
	 			if (declProcessed) {
					if (exprType != VarType.OBJECT) {
						System.err.println("Error: " + $id.line + ": non-object type cannot be dereferenced");
						err = true;
					}
				}
			}
	)
	dot_subexpr_ *
	; 

dot_subexpr_ :
	 '.'
	 (
	  field=Identifier
	 		{
				if (declProcessed) {
					int fieldOffset = -1;
					final SemInfo sinfo[] = new SemInfo[1];
					fieldOffset = getField(currentObjType, $field.text, sinfo);
					if (fieldOffset >= 1) {
						exprType = sinfo[0].type;
						if (exprType == VarType.OBJECT) {
						      currentObjType = sinfo[0].clsName;
						}
						if (!err) {
							System.out.println("\taddi\t\$t0,\t\$t0,\t" + (fieldOffset << 2));
							System.out.println("\tlw\t\$t0,\t(\$t0)");
						}
					}else {
						System.err.println("Error: " + getCurrentToken().getLine() + ": unknown field '" + $field.text + "'");
						err = true;
					}
				}else if (postProcessDecl) {
					exprType = getIdType($field.text, currentObjType);
					if (exprType == VarType.OBJECT) {
						currentObjType = getObjectVarClsName($field.text, currentObjType);
					}else {
						currentObjType = null;
					}
				}
			}
	 |
	 		{
				thisMethodCall = false;
			}
	  methodcall
	  		{
				if (declProcessed) {	
					if (!err) {
						System.out.println("\tmove\t\$t0,\t\$v0");
					}
				}
			}
	)
	;

dot_subexpr_field :
	dot_subexpr_ref
	'.'
	field=Identifier
	 		{
				if (declProcessed) {
					int fieldOffset = -1;
					final SemInfo sinfo[] = new SemInfo[1];
					fieldOffset = getField(currentObjType, $field.text, sinfo);
					if (fieldOffset >= 1) {
						exprType = sinfo[0].type;
						if (exprType == VarType.OBJECT) {
							currentObjType = sinfo[0].clsName;
						}
						if (!err) {
							System.out.println("\tlw\t\$v0,\t" + (fieldOffset << 2) + "(\$t0)");
						}
					}else {
						System.err.println("Error: " + getCurrentToken().getLine() + ": unknown field '" + $field.text + "'");
						err = true;
					}
				}else if (postProcessDecl) {
					exprType = getIdType($field.text, currentObjType);
					if (exprType == VarType.OBJECT) {
						currentObjType = getObjectVarClsName($field.text, currentObjType);
					}else {
						currentObjType = null;
					}
				}
			}
	; 

dot_subexpr_field_l_value :
	dot_subexpr_ref
	'.'
	field=Identifier
	 		{
				if (declProcessed) {
					int fieldOffset = -1;
					final SemInfo sinfo[] = new SemInfo[1];
					fieldOffset = getField(currentObjType, $field.text, sinfo);
					if (fieldOffset >= 1) {
						exprType = sinfo[0].type;
						if (exprType == VarType.OBJECT) {
							currentObjType = sinfo[0].clsName;
						}
						if (!err) {
							System.out.println("\taddi\t\$t0,\t\$t0,\t" + (fieldOffset << 2));
						}
					}else {
						System.err.println("Error: " + getCurrentToken().getLine() + ": unknown field '" + $field.text + "'");
						err = true;
					}
				}else if (postProcessDecl) {
					exprType = getIdType($field.text, currentObjType);
					if (exprType == VarType.OBJECT) {
						currentObjType = getObjectVarClsName($field.text, currentObjType);
					}else {
						currentObjType = null;
					}
				}
			}
	; 

dot_subexpr_methodcall :
	dot_subexpr_ref
	'.'
	 		{
				thisMethodCall = false;
			}
	  methodcall
	; 
	
/*------------------------------------------------------------------
 * LEXER RULES
 *------------------------------------------------------------------*/

Negation :
	('!')+
	;

BooleanLiteral :
	'true'
	|
	'false'
	;

IntegerLiteral :
	[0-9]+
	;

StringLiteral :
	'"'  (~('"' | '\\') | '\\' '\'' | '\\' '"' | '\\' '\\' | '\\' 't' | '\\' 'b' | '\\' 'n' | '\\' 'r' | '\\' 'f')* '"'
	;

ObjectLiteral :
	'this'
	|
	'null'
	;

Identifier :
	[a-zA-Z_][a-zA-Z0-9_]*
	;

SA_Comment :
	'/*' .*? '*/' -> skip
	;

SS_Comment :
	'//' .*? [\r\n] -> skip
	;

WS :
	[ \t\r\n]+ -> skip
	;
