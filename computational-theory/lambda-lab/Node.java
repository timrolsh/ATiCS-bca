public class Node {
    public Variable val;
    public Node left;
    public Node right;

    public Node(Variable val, Node left, Node right) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}
