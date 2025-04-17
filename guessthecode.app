import { useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import {
  Select,
  SelectTrigger,
  SelectValue,
  SelectContent,
  SelectItem,
} from "@/components/ui/select";
import { Tabs, TabsList, TabsTrigger, TabsContent } from "@/components/ui/tabs";

export default function App() {
  const positions = ["A", "B", "C", "D", "E"];
  const initialAnnotations = {
    somaABC: "",
    somaBCD: "",
    somaCDE: "",
    somaABCDE: "",
    qtdPretos: "",
    qtdBrancos: "",
    qtdPares: "",
    qtdImpares: "",
    numberMarks: Array(10).fill(false),
  };

  const [players, setPlayers] = useState([
    {
      id: "jogador1",
      name: "Jogador 1",
      code: positions.map(() => ({ number: "", color: "" })),
      annotations: { ...initialAnnotations },
    },
    {
      id: "jogador2",
      name: "Jogador 2",
      code: positions.map(() => ({ number: "", color: "" })),
      annotations: { ...initialAnnotations },
    },
  ]);
  const [activeTab, setActiveTab] = useState(players[0].id);

  const handleChange = (playerIndex, positionIndex, field, value) => {
    const updatedPlayers = [...players];
    updatedPlayers[playerIndex].code[positionIndex][field] = value;
    setPlayers(updatedPlayers);
  };

  const handleAnnotationChange = (playerIndex, field, value) => {
    const updatedPlayers = [...players];
    updatedPlayers[playerIndex].annotations[field] = value;
    setPlayers(updatedPlayers);
  };

  const toggleNumberMark = (playerIndex, number) => {
    const updatedPlayers = [...players];
    updatedPlayers[playerIndex].annotations.numberMarks[number] =
      !updatedPlayers[playerIndex].annotations.numberMarks[number];
    setPlayers(updatedPlayers);
  };

  const addPlayer = () => {
    const newPlayer = {
      id: `jogador${players.length + 1}`,
      name: `Jogador ${players.length + 1}`,
      code: positions.map(() => ({ number: "", color: "" })),
      annotations: { ...initialAnnotations },
    };
    setPlayers([...players, newPlayer]);
  };

  const resetAll = () => {
    const resetPlayers = players.map((p) => ({
      ...p,
      code: positions.map(() => ({ number: "", color: "" })),
      annotations: { ...initialAnnotations },
    }));
    setPlayers(resetPlayers);
    setActiveTab(resetPlayers[0].id);
  };

  const colorBox = (color) => (
    <div
      className={`w-4 h-4 rounded-full mx-auto ${
        color === "preto" ? "bg-black" : color === "branco" ? "bg-white border" : "bg-green-500"
      }`}
    />
  );

  return (
    <div className="p-4 max-w-md mx-auto space-y-6">
      <h1 className="text-2xl font-bold text-center">Qual é o Código?</h1>

      <Tabs value={activeTab} onValueChange={setActiveTab} className="w-full">
        <TabsList className="grid grid-cols-2 overflow-x-auto">
          {players.map((player) => (
            <TabsTrigger key={player.id} value={player.id}>
              {player.name}
            </TabsTrigger>
          ))}
          <Button variant="outline" onClick={addPlayer} className="text-xs px-2 py-1">
            + Jogador
          </Button>
        </TabsList>

        {players.map((player, playerIndex) => (
          <TabsContent key={player.id} value={player.id}>
            <Card className="mt-4">
              <CardContent className="space-y-4 pt-4">
                <h2 className="text-lg font-semibold">{player.name} - Código Secreto</h2>
                <div className="grid grid-cols-5 gap-2">
                  {positions.map((label, i) => (
                    <div key={label} className="space-y-1">
                      <Input
                        type="number"
                        min="0"
                        max="9"
                        placeholder={label}
                        value={player.code[i].number}
                        onChange={(e) => handleChange(playerIndex, i, "number", e.target.value)}
                        className="text-center"
                      />
                      <Select
                        onValueChange={(value) => handleChange(playerIndex, i, "color", value)}
                        value={player.code[i].color}
                      >
                        <SelectTrigger>{colorBox(player.code[i].color)}</SelectTrigger>
                        <SelectContent>
                          <SelectItem value="branco">{colorBox("branco")}</SelectItem>
                          <SelectItem value="preto">{colorBox("preto")}</SelectItem>
                          <SelectItem value="verde">{colorBox("verde")}</SelectItem>
                        </SelectContent>
                      </Select>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>

            <Card className="mt-4">
              <CardContent className="space-y-4 pt-4">
                <h2 className="text-lg font-semibold">Anotações & Deduções</h2>
                <div className="grid grid-cols-2 gap-2">
                  <Input placeholder="Soma ABC" value={player.annotations.somaABC} onChange={(e) => handleAnnotationChange(playerIndex, "somaABC", e.target.value)} />
                  <Input placeholder="Soma BCD" value={player.annotations.somaBCD} onChange={(e) => handleAnnotationChange(playerIndex, "somaBCD", e.target.value)} />
                  <Input placeholder="Soma CDE" value={player.annotations.somaCDE} onChange={(e) => handleAnnotationChange(playerIndex, "somaCDE", e.target.value)} />
                  <Input placeholder="Soma ABCDE" value={player.annotations.somaABCDE} onChange={(e) => handleAnnotationChange(playerIndex, "somaABCDE", e.target.value)} />
                  <Input placeholder="Qtd. Pretos" value={player.annotations.qtdPretos} onChange={(e) => handleAnnotationChange(playerIndex, "qtdPretos", e.target.value)} />
                  <Input placeholder="Qtd. Brancos" value={player.annotations.qtdBrancos} onChange={(e) => handleAnnotationChange(playerIndex, "qtdBrancos", e.target.value)} />
                  <Input placeholder="Qtd. Pares" value={player.annotations.qtdPares} onChange={(e) => handleAnnotationChange(playerIndex, "qtdPares", e.target.value)} />
                  <Input placeholder="Qtd. Ímpares" value={player.annotations.qtdImpares} onChange={(e) => handleAnnotationChange(playerIndex, "qtdImpares", e.target.value)} />
                </div>
                <div className="pt-2">
                  <h3 className="font-medium">Números Possíveis</h3>
                  <div className="grid grid-cols-10 gap-1 mt-2">
                    {[...Array(10)].map((_, i) => (
                      <button
                        key={i}
                        onClick={() => toggleNumberMark(playerIndex, i)}
                        className={`w-8 h-8 border rounded flex items-center justify-center text-sm font-bold ${
                          player.annotations.numberMarks[i] ? "bg-red-500 text-white" : "bg-white"
                        }`}
                      >
                        {player.annotations.numberMarks[i] ? "X" : i}
                      </button>
                    ))}
                  </div>
                </div>
              </CardContent>
            </Card>
          </TabsContent>
        ))}
      </Tabs>

      <Button className="w-full" onClick={resetAll}>Reiniciar Jogo</Button>
    </div>
  );
}
