import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;

public class Main {

	static class Vec3 {
		public long x, y, z;
		public ArrayList<Vec3> circuit;
		public Vec3(long x, long y, long z) {
			this.x = x;
			this.y = y;
			this.z = z;
		}

		public static Vec3 parse(String s) {
			String[] p = s.split(",");
			return new Vec3(Long.parseUnsignedLong(p[0]), Long.parseUnsignedLong(p[1]), Long.parseUnsignedLong(p[2]));
		}
		
		public static ArrayList<Vec3> parseMulti(String s) {
			String[] lines = s.split("\n");
			ArrayList<Vec3> result = new ArrayList<>();
			for (String line : lines) result.add(parse(line));
			return result;
		}
		
		public static long distSq(Vec3 a, Vec3 b) {
			long dx = a.x - b.x, dy = a.y - b.y, dz = a.z - b.z;
			return dx * dx + dy * dy + dz * dz;
		}
	
	}

	static class Dist3 {
		public Vec3 u, v;
		public long dist;
	
		public Dist3(Vec3 u, Vec3 v) {
			this.u = u;
			this.v = v;
			this.dist = Vec3.distSq(u, v);
		}
	
	}

	public static void main(String[] args) {
	
		if (args.length < 2) {
			System.out.println("Provide filepath and part to solve (1 or 2)");
			return;
		}

		String part = args[1];
		try {
			
			String content = Files.readString(Paths.get(args[0]));
			ArrayList<Vec3> boxes = Vec3.parseMulti(content);
			ArrayList<Dist3> distances = new ArrayList<>();
			ArrayList<ArrayList<Vec3>> circuits = new ArrayList<>();
			
			for (Vec3 box : boxes) {
				ArrayList<Vec3> circuit = new ArrayList<>();
				circuit.add(box);
				box.circuit = circuit;
				circuits.add(circuit);
			}
			
			for (int k = 0; k < boxes.size() - 1; k++) {
				for (int i = k + 1; i < boxes.size(); i++) distances.add(new Dist3(boxes.get(k), boxes.get(i)));
			}
			
			distances.sort((a, b) -> Long.compare(a.dist, b.dist));
			int maxLen = part.equals("1") ? boxes.size() : distances.size();
			for (Dist3 dist : distances.subList(0, maxLen)) {
				if (dist.u.circuit == dist.v.circuit) continue;
				ArrayList<Vec3> c1 = dist.u.circuit;
				ArrayList<Vec3> c2 = dist.v.circuit;
				for (Vec3 vec : c1) {
					vec.circuit = c2;
					c2.add(vec);
				}
				c1.clear();
				circuits.remove(c1);
				if (part.charAt(0) == '2' && circuits.size() == 1) {
					System.out.println(dist.u.x * dist.v.x);
					return;
				}
			}
			
			circuits.sort((a, b) -> Long.compare(b.size(), a.size()));
			long result = 1;	
			for (int i = 0; i < 3; i++) {
				result *= circuits.get(i).size();
			}
			System.out.println(result);
		
		} catch (IOException e) {
			e.printStackTrace();
		}
	
	}
}
